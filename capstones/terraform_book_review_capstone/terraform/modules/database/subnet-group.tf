# -----------------------------------------------------------------------------
# DB Subnet Group
# Spans both private database tier subnets (one per AZ) so the primary
# instance's Multi-AZ standby and the read replica can each be placed in a
# different availability zone. Never includes web or app tier subnets.
# -----------------------------------------------------------------------------
resource "aws_db_subnet_group" "this" {
  name        = "${var.project_name}-${var.environment}-db-subnet-group"
  description = "Private DB tier subnet group spanning both availability zones"
  subnet_ids  = var.db_subnet_ids

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  })
}
