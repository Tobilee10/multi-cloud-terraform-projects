# -----------------------------------------------------------------------------
# Read Replica
# Separate, visible, asynchronously-replicated copy of the primary instance
# for read scaling. This is NOT the Multi-AZ standby - it has its own
# endpoint and the application must be explicitly coded to send read-only
# queries to it. Placed in the second availability zone (distinct from
# where the primary's active endpoint currently runs) for higher
# availability of the read path.
#
# engine, db_name, username, password, and allocated_storage are
# intentionally omitted - they are inherited from replicate_source_db and
# cannot be set independently on a same-region MySQL read replica.
# -----------------------------------------------------------------------------
resource "aws_db_instance" "read_replica" {
  identifier          = "${var.project_name}-${var.environment}-mysql-replica"
  replicate_source_db = aws_db_instance.primary.identifier

  instance_class    = var.db_instance_class
  availability_zone = coalesce(var.replica_availability_zone, var.availability_zones[1])

  publicly_accessible    = false
  vpc_security_group_ids = [var.db_sg_id]
  storage_encrypted      = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-mysql-replica"
  })
}
