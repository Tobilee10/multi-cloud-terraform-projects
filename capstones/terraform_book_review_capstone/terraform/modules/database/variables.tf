variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC the database tier belongs to (used for validation/reference only)"
  type        = string
}

variable "db_subnet_ids" {
  description = "IDs of the private database tier subnets, one per AZ (module.network.db_subnet_ids)"
  type        = list(string)
}

variable "db_sg_id" {
  description = "ID of the database tier security group - only allows MySQL (3306) from the App tier"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones used for subnet distribution (module.network.availability_zones)"
  type        = list(string)
}

variable "db_instance_class" {
  description = "RDS instance class for both the primary instance and the read replica"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = <<-EOT
    Name of the initial database created on the primary instance. Confirmed
    against the book-review-app backend (backend/src/config/db.js reads
    process.env.DB_NAME, and docker-compose.yml sets DB_NAME=book_review_db).
  EOT
  type        = string
  default     = "book_review_db"
}

variable "db_master_username" {
  description = <<-EOT
    Master username for the RDS instance. Deliberately not "root" - AWS RDS
    for MySQL rejects "root" as a master username. Phase 6 (Application
    Deployment) must set the App tier's DB_USER env var to match this value.
  EOT
  type        = string
  default     = "admin"
}

variable "mysql_port" {
  description = "Port the managed MySQL database listens on. Only reachable from the App tier."
  type        = number
  default     = 3306
}

variable "engine_version" {
  description = "MySQL engine version (major.minor prefix). AWS resolves to the latest matching patch version."
  type        = string
  default     = "8.0"
}

variable "allocated_storage" {
  description = "Allocated storage in GiB for the primary instance"
  type        = number
  default     = 20
}

variable "backup_retention_period" {
  description = "Days to retain automated backups. Must be > 0 for the instance to be usable as a read replica source."
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = <<-EOT
    Whether the primary RDS instance has deletion protection enabled. Defaults
    to true (production-like safety). Must be explicitly overridden to false
    before terraform destroy can succeed on the primary instance.
  EOT
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Whether to skip taking a final snapshot when the primary instance is deleted"
  type        = bool
  default     = false
}

variable "replica_availability_zone" {
  description = <<-EOT
    Availability zone for the read replica. Defaults to the second AZ in
    availability_zones (index 1) so the replica is distributed away from the
    primary's current AZ for higher availability of the read path.
  EOT
  type        = string
  default     = null
}

variable "tags" {
  description = "Common tags applied to all database resources"
  type        = map(string)
  default     = {}
}
