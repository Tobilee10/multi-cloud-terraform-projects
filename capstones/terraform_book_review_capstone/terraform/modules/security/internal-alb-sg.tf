# -----------------------------------------------------------------------------
# Internal ALB Security Group
# Not internet-facing. Only accepts traffic from the Web tier and forwards it
# to the App tier on the backend port. No rule in this security group
# references 0.0.0.0/0.
# -----------------------------------------------------------------------------
resource "aws_security_group" "internal_alb" {
  name        = "${var.project_name}-${var.environment}-internal-alb-sg"
  description = "Internal ALB - Web tier to App tier only, no internet exposure"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-internal-alb-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "internal_alb_from_web" {
  security_group_id            = aws_security_group.internal_alb.id
  description                  = "Allow backend traffic from the Web tier"
  referenced_security_group_id = aws_security_group.web.id
  from_port                    = var.backend_port
  to_port                      = var.backend_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "internal_alb_to_app" {
  security_group_id            = aws_security_group.internal_alb.id
  description                  = "Forward backend traffic to the App tier"
  referenced_security_group_id = aws_security_group.app.id
  from_port                    = var.backend_port
  to_port                      = var.backend_port
  ip_protocol                  = "tcp"
}
