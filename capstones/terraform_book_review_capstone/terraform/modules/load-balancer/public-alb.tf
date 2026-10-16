# -----------------------------------------------------------------------------
# Public Application Load Balancer
# Internet-facing entry point for the Web tier. Placed in the public subnets
# from the network module and attached to the public-alb-sg created in
# Phase 2 (modules/security/public-alb-sg.tf). No security group changes are
# made here - this module only consumes the existing SG ID as an input.
# -----------------------------------------------------------------------------
resource "aws_lb" "public" {
  name               = "${var.project_name}-${var.environment}-public-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_alb_sg_id]
  subnets            = var.public_subnet_ids

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-public-alb"
  })
}

# -----------------------------------------------------------------------------
# Web tier target group
# Port is a placeholder (var.web_app_port, default 3000) pending confirmation
# against the book-review-app repository. Instances are registered in
# Phase 5 (Compute) via aws_lb_target_group_attachment.
# -----------------------------------------------------------------------------
resource "aws_lb_target_group" "web" {
  name        = "${var.project_name}-${var.environment}-web-tg"
  port        = var.web_app_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = var.web_health_check_path
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 6
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-web-tg"
  })
}

resource "aws_lb_listener" "public_http" {
  load_balancer_arn = aws_lb.public.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# -----------------------------------------------------------------------------
# Optional HTTPS listener - only created once an ACM certificate ARN is
# supplied. Deferred by default (var.certificate_arn = "") pending domain /
# certificate provisioning.
# -----------------------------------------------------------------------------
resource "aws_lb_listener" "public_https" {
  count = var.certificate_arn != "" ? 1 : 0

  load_balancer_arn = aws_lb.public.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}
