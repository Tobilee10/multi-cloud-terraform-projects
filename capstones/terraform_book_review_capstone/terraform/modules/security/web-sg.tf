# -----------------------------------------------------------------------------
# Web Tier Security Group
# Instances sit in public subnets but only accept application traffic from
# the Public ALB - never directly from the internet. No HTTP/HTTPS ingress is
# opened here; that belongs to the public-alb-sg until the ALB exists
# (Phase 3). SSH is permitted from var.ssh_ingress_cidr (0.0.0.0/0 by default)
# per explicit approval for this short-lived test environment - see the
# warning documented on that variable.
# -----------------------------------------------------------------------------
resource "aws_security_group" "web" {
  name        = "${var.project_name}-${var.environment}-web-sg"
  description = "Web tier - accepts app traffic from the public ALB only"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-web-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "web_from_public_alb" {
  security_group_id            = aws_security_group.web.id
  description                  = "Allow app traffic from the public ALB"
  referenced_security_group_id = aws_security_group.public_alb.id
  from_port                    = var.web_app_port
  to_port                      = var.web_app_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "web_ssh" {
  security_group_id = aws_security_group.web.id
  description       = "SSH - jump host convenience on short-lived test environment (see var.ssh_ingress_cidr warning)"
  cidr_ipv4         = var.ssh_ingress_cidr
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "web_to_internal_alb" {
  security_group_id            = aws_security_group.web.id
  description                  = "Forward backend traffic to the internal ALB / App tier"
  referenced_security_group_id = aws_security_group.internal_alb.id
  from_port                    = var.backend_port
  to_port                      = var.backend_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "web_https_out" {
  security_group_id = aws_security_group.web.id
  description       = "Outbound HTTPS for package installs, SSM, OS updates"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "web_http_out" {
  security_group_id = aws_security_group.web.id
  description       = "Outbound HTTP for package mirrors / OS updates"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}
