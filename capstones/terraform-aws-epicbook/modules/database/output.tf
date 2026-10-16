output "db_instance_id" {
    description = "The ID of the RDS instance"
    value       = aws_db_instance.db_instance.id
}

output "db_instance_arn" {
    description = "The ARN of the RDS instance"
    value       = aws_db_instance.db_instance.arn
}

output "db_instance_endpoint" {
    description = "The endpoint of the RDS instance"
    value       = aws_db_instance.db_instance.endpoint
}

output "db_address" {
    description  = "The address or hostname  of the RDS instance"
    value        = aws_db_instance.db_instance.address
}

output "db_port" {
    description = "The port on which the database accepts connections"
    value       = aws_db_instance.db_instance.port
}

output "db_name" {
    description = "The name of the database"
    value       = aws_db_instance.db_instance.db_name
}

output "db_username" {
    description = "The username for the database"
    value       = aws_db_instance.db_instance.username
}

output "db_subnet_group_name" {
    description = "The name of the DB subnet group"
    value       = aws_db_subnet_group.db_subnet-group.name
}