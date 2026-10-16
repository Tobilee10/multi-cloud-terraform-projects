output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "availability_zones" {
  description = "Availability zones used for subnet distribution"
  value       = local.az_names
}

output "public_subnet_ids" {
  description = "IDs of the public (web tier) subnets"
  value       = aws_subnet.public[*].id
}

output "app_subnet_ids" {
  description = "IDs of the private application tier subnets"
  value       = aws_subnet.app[*].id
}

output "db_subnet_ids" {
  description = "IDs of the private database tier subnets"
  value       = aws_subnet.db[*].id
}

output "public_route_table_id" {
  description = "ID of the shared public route table"
  value       = aws_route_table.public.id
}

output "app_route_table_ids" {
  description = "IDs of the per-AZ application tier route tables"
  value       = aws_route_table.app[*].id
}

output "db_route_table_id" {
  description = "ID of the shared database tier route table (no internet route)"
  value       = aws_route_table.db.id
}

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways"
  value       = aws_nat_gateway.main[*].id
}
