# -----------------------------------------------------------------------------
# Outputs
# Deliberately expose only connection metadata and a Secrets Manager ARN -
# never the master password itself. The password lives only in AWS Secrets
# Manager (created via manage_master_user_password on the primary instance)
# and is never read into Terraform state or outputs.
# -----------------------------------------------------------------------------
output "primary_endpoint" {
  description = "DNS address of the primary RDS instance (no port) - connect via the App tier only"
  value       = aws_db_instance.primary.address
}

output "primary_port" {
  description = "Port the primary RDS instance listens on"
  value       = aws_db_instance.primary.port
}

output "replica_endpoint" {
  description = "DNS address of the read replica - for read-only queries only, not used for failover"
  value       = aws_db_instance.read_replica.address
}

output "db_name" {
  description = "Name of the initial database on the primary instance"
  value       = var.db_name
}

output "master_username" {
  description = "Master username for the primary RDS instance (not a secret - the password is managed separately in Secrets Manager)"
  value       = var.db_master_username
}

output "master_user_secret_arn" {
  description = "ARN of the AWS Secrets Manager secret holding the master password. This is a pointer, not the password value - retrieve the password at runtime via the AWS Secrets Manager API/SDK, never from Terraform state or output."
  value       = aws_db_instance.primary.master_user_secret[0].secret_arn
}

output "db_sg_id" {
  description = "ID of the database tier security group (pass-through for auditing/reference)"
  value       = var.db_sg_id
}
