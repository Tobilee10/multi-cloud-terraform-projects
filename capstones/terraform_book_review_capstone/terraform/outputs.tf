output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = module.network.vpc_cidr_block
}

output "availability_zones" {
  description = "Availability zones used for subnet distribution"
  value       = module.network.availability_zones
}

output "public_subnet_ids" {
  description = "IDs of the public (web tier) subnets"
  value       = module.network.public_subnet_ids
}

output "app_subnet_ids" {
  description = "IDs of the private application tier subnets"
  value       = module.network.app_subnet_ids
}

output "db_subnet_ids" {
  description = "IDs of the private database tier subnets"
  value       = module.network.db_subnet_ids
}

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways"
  value       = module.network.nat_gateway_ids
}

output "public_alb_sg_id" {
  description = "ID of the public ALB security group (internet-facing)"
  value       = module.security.public_alb_sg_id
}

output "web_sg_id" {
  description = "ID of the web tier security group"
  value       = module.security.web_sg_id
}

output "internal_alb_sg_id" {
  description = "ID of the internal ALB security group (Web tier to App tier)"
  value       = module.security.internal_alb_sg_id
}

output "app_sg_id" {
  description = "ID of the application tier security group"
  value       = module.security.app_sg_id
}

output "db_sg_id" {
  description = "ID of the database tier security group"
  value       = module.security.db_sg_id
}

output "public_alb_dns_name" {
  description = "DNS name of the public ALB (internet-facing entry point)"
  value       = module.load_balancer.public_alb_dns_name
}

output "public_alb_arn" {
  description = "ARN of the public ALB"
  value       = module.load_balancer.public_alb_arn
}

output "internal_alb_dns_name" {
  description = "DNS name of the internal ALB (Web tier -> App tier)"
  value       = module.load_balancer.internal_alb_dns_name
}

output "internal_alb_arn" {
  description = "ARN of the internal ALB"
  value       = module.load_balancer.internal_alb_arn
}

output "internal_alb_target_group_arn" {
  description = "ARN of the backend (App tier) target group - consumed by Phase 5 to attach EC2 instances"
  value       = module.load_balancer.internal_alb_target_group_arn
}

output "web_target_group_arn" {
  description = "ARN of the web (Web tier) target group - consumed by Phase 5 to attach EC2 instances"
  value       = module.load_balancer.web_target_group_arn
}

output "primary_endpoint" {
  description = "DNS address of the primary RDS MySQL instance (no port) - connect via the App tier only"
  value       = module.database.primary_endpoint
}

output "primary_port" {
  description = "Port the primary RDS MySQL instance listens on"
  value       = module.database.primary_port
}

output "replica_endpoint" {
  description = "DNS address of the RDS read replica - for read-only queries only, not used for failover"
  value       = module.database.replica_endpoint
}

output "db_name" {
  description = "Name of the initial database on the primary RDS instance"
  value       = module.database.db_name
}

output "master_username" {
  description = "Master username for the primary RDS instance (not a secret - the password is managed separately in Secrets Manager)"
  value       = module.database.master_username
}

output "master_user_secret_arn" {
  description = "ARN of the AWS Secrets Manager secret holding the master password. This is a pointer, not the password value - retrieve the password at runtime via the AWS Secrets Manager API/SDK, never from Terraform state or output."
  value       = module.database.master_user_secret_arn
}
