output "public_alb_sg_id" {
  description = "ID of the public ALB security group (internet-facing)"
  value       = aws_security_group.public_alb.id
}

output "web_sg_id" {
  description = "ID of the web tier security group"
  value       = aws_security_group.web.id
}

output "internal_alb_sg_id" {
  description = "ID of the internal ALB security group (Web tier to App tier)"
  value       = aws_security_group.internal_alb.id
}

output "app_sg_id" {
  description = "ID of the application tier security group"
  value       = aws_security_group.app.id
}

output "db_sg_id" {
  description = "ID of the database tier security group"
  value       = aws_security_group.db.id
}
