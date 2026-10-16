# -----------------------------------------------------------------------------
# Application Tier Security Group
# Private subnets. Accepts backend traffic only from the internal ALB and SSH
# only from the Web tier (SG-to-SG reference, never 0.0.0.0/0). Backend port
# 3001 is never exposed outside the internal-alb-sg -> app-sg boundary.
# -----------------------------------------------------------------------------
resource "aws_security_group" "app" {
  name        = "${var.project_name}-${var.environment}-app-sg"
  description = "App tier - accepts backend traffic from the internal ALB only"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-app-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "app_from_internal_alb" {
  security_group_id            = aws_security_group.app.id
  description                  = "Allow backend traffic from the internal ALB"
  referenced_security_group_id = aws_security_group.internal_alb.id
  from_port                    = var.backend_port
  to_port                      = var.backend_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "app_ssh_from_web" {
  security_group_id            = aws_security_group.app.id
  description                  = "SSH from the Web tier only (SG-to-SG reference, no 0.0.0.0/0)"
  referenced_security_group_id = aws_security_group.web.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "app_to_db" {
  security_group_id            = aws_security_group.app.id
  description                  = "Allow MySQL traffic to the DB tier"
  referenced_security_group_id = aws_security_group.db.id
  from_port                    = var.mysql_port
  to_port                      = var.mysql_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "app_https_out" {
  security_group_id = aws_security_group.app.id
  description       = "Outbound HTTPS for npm/SSM/external APIs (via NAT)"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "app_http_out" {
  security_group_id = aws_security_group.app.id
  description       = "Outbound HTTP for package mirrors (via NAT)"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}
