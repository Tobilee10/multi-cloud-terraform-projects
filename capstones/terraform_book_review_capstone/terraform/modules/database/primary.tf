# -----------------------------------------------------------------------------
# Primary RDS MySQL Instance
# Multi-AZ enabled: AWS provisions and manages an invisible synchronous
# standby in a second AZ and automatically fails over to it on instance
# failure. The app always connects to this single instance's endpoint;
# failover is transparent. Not publicly accessible - reachable only from the
# App tier via db_sg_id (see modules/security/db-sg.tf).
#
# Master password is managed by AWS Secrets Manager (manage_master_user_password
# = true) rather than a Terraform variable. This means Terraform never
# receives, stores, or outputs the plaintext password - only a Secrets
# Manager secret ARN. Automatic secret rotation is intentionally left
# disabled (no aws_secretsmanager_secret_rotation resource here) so the
# generated password stays stable for the life of this capstone environment,
# since the App tier is expected to read a static DB_PASS value at bootstrap
# rather than re-fetching a rotating secret at runtime.
# -----------------------------------------------------------------------------
resource "aws_db_instance" "primary" {
  identifier     = "${var.project_name}-${var.environment}-mysql"
  engine         = "mysql"
  engine_version = var.engine_version
  instance_class = var.db_instance_class

  allocated_storage = var.allocated_storage
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_master_username
  port     = var.mysql_port

  manage_master_user_password = true
  # password / password_wo intentionally omitted - mutually exclusive with
  # manage_master_user_password and would otherwise store the credential in
  # plaintext in Terraform state.

  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.db_sg_id]
  publicly_accessible    = false

  backup_retention_period = var.backup_retention_period
  deletion_protection     = var.deletion_protection
  skip_final_snapshot     = var.skip_final_snapshot

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-mysql-primary"
  })
}
