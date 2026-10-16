# -----------------------------------------------------------------------------
# Public ALB Security Group
# Internet-facing entry point. This is the ONLY security group in this module
# permitted to receive traffic from 0.0.0.0/0. Terminates HTTP/HTTPS from the
# internet and forwards to the Web tier on the web application port only.
# The ALB resource itself is created in Phase 3 (Load Balancing); this module
# only provisions the security group it will attach to.
# -----------------------------------------------------------------------------
resource "aws_security_group" "public_alb" {
  name        = "${var.project_name}-${var.environment}-public-alb-sg"
  description = "Public-facing ALB - accepts HTTP/HTTPS from the internet"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-public-alb-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "public_alb_http" {
  security_group_id = aws_security_group.public_alb.id
  description       = "Allow HTTP from the internet"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "public_alb_https" {
  security_group_id = aws_security_group.public_alb.id
  description       = "Allow HTTPS from the internet"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "public_alb_to_web" {
  security_group_id            = aws_security_group.public_alb.id
  description                  = "Forward application traffic to the Web tier"
  referenced_security_group_id = aws_security_group.web.id
  from_port                    = var.web_app_port
  to_port                      = var.web_app_port
  ip_protocol                  = "tcp"
}
