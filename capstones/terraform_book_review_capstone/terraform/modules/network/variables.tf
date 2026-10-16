variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public (web tier) subnets, one per AZ"
  type        = list(string)
}

variable "app_subnet_cidrs" {
  description = "CIDR blocks for private application tier subnets, one per AZ"
  type        = list(string)
}

variable "db_subnet_cidrs" {
  description = "CIDR blocks for private database tier subnets, one per AZ"
  type        = list(string)
}

variable "az_count" {
  description = "Number of availability zones to spread subnets across"
  type        = number
  default     = 2
}

variable "single_nat_gateway" {
  description = "If true, provision a single shared NAT Gateway for all AZs (lower cost, reduced HA). If false, provision one NAT Gateway per AZ (default, matches production HA requirement)."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags applied to all network resources"
  type        = map(string)
  default     = {}
}
