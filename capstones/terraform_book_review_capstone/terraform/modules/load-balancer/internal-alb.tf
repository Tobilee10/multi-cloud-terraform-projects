# -----------------------------------------------------------------------------
# Internal Application Load Balancer
# Not internet-facing. Placed in the private application tier subnets from
# the network module and attached to the internal-alb-sg created in Phase 2
# (modules/security/internal-alb-sg.tf). No security group changes are made
# here - this module only consumes the existing SG ID as an input.
# -----------------------------------------------------------------------------
resource "aws_lb" "internal" {
  name               = "${var.project_name}-${var.environment}-internal-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.internal_alb_sg_id]
  subnets            = var.app_subnet_ids

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-internal-alb"
  })
}

# -----------------------------------------------------------------------------
# Backend (App tier) target group
# Port is var.backend_port (3001), never exposed publicly. Instances are
# registered in Phase 5 (Compute) via aws_lb_target_group_attachment.
# -----------------------------------------------------------------------------
resource "aws_lb_target_group" "backend" {
  name        = "${var.project_name}-${var.environment}-backend-tg"
  port        = var.backend_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = var.backend_health_check_path
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 6
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-backend-tg"
  })
}

resource "aws_lb_listener" "internal_backend" {
  load_balancer_arn = aws_lb.internal.arn
  port              = var.backend_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}
