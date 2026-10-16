# -----------------------------------------------------------------------------
# Database Tier Security Group
# Private subnets, no internet route (see the network module's DB route
# table, which has no NAT/IGW route as a second layer of defense). Accepts
# MySQL traffic only from the App tier. Deliberately has NO egress rules -
# the database never needs to initiate outbound connections.
# -----------------------------------------------------------------------------
resource "aws_security_group" "db" {
  name        = "${var.project_name}-${var.environment}-db-sg"
  description = "Database tier - accepts MySQL traffic from the App tier only"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-db-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "db_from_app" {
  security_group_id            = aws_security_group.db.id
  description                  = "Allow MySQL traffic from the App tier only"
  referenced_security_group_id = aws_security_group.app.id
  from_port                    = var.mysql_port
  to_port                      = var.mysql_port
  ip_protocol                  = "tcp"
}
