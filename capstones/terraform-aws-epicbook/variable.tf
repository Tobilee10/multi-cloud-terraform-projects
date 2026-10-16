### Networking

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}


variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type        = string
}   


variable "private_db_subnetA_cidr" {
  description = "The CIDR block for the private database subnetA"
  type        = string  
}

variable "private_db_subnetB_cidr" {
  description = "The CIDR block for the private database subnetB"
  type        = string  
}

variable "availability_zones" {
  description = "The availability zones for the subnets"
  type        = list(string)
}

variable "security_group_names" {
  description = "The name of the security group"
  type        = map(string)
  default     = {
    web = "eb-web-sg"
    db  = "eb-db-sg"
  }
}

### Instance

variable "ami_id" {
    description = "The AMI ID for the instance"
    type        = string
}
variable "instance_type" {
    description = "The type of instance to create"
    type        = string
}


variable "public_key_path" {
  description = "The path to the public key file"
  type        = string
}

variable "key_name" {
    description = "The name of the key pair to use for the instance"
    type        = string
}


# variable "user_data" {
#   description = "The user data script to run on instance launch"
#   type        = string
# }

### Database

variable "db_subnet_group_name" {
    description = "The name of the DB subnet group"
    type        = string
}

# variable "private_db_subnet_ids" {
#     description = "The IDs of the private DB subnets"
#     type        = list(string)
# }

variable "db_identifier" {
    description = "The identifier for the DB instance"
    type        = string
}

# variable "security_group_ids" {
#     description = "The IDs of the security groups to associate with the DB instanc"
#     type        = list(string)
# }

variable "engine_version" {
    description = "The version of the database engine"
    type        = string
    default    = "8.0"
}

variable "instance_class" {
    description = "The instance class for the DB instance"
    type        = string
    default     = "db.t3.micro"
}

variable "allocated_storage" {
    description = "The allocated storage in gigabytes"
    type        = number
    default     = 20
}

variable "max_allocated_storage" {
    description = "The maximum allocated storage in gigabytes"
    type        = number
    default     = 100
}

variable "storage_type" {
    description = "The storage type for the DB instance"
    type        = string
    default     = "gp3"
}

variable "db_name" {
    description = "The name of the database to create"
    type        = string
}

variable "db_username" {
    description = "The username for the database"
    type        = string
}

variable "db_password" {
    description = "The password for the database"
    type        = string
    sensitive   = true
}


variable "db_port" {
    description = "The port on which the database accepts connections"
    type        = number
    default     = 3306
}

variable "multi_az" {
    description = "Specifies if the RDS instance is multi-AZ"
    type        = bool
    default     = false
}

variable "backup_retention_period" {
    description = "The number of days to retain backups"
    type        = number
    default     = 7
}

variable "backup_window" {
    description = "The daily time range during which automated backups are created"
    type        = string
    default     = "03:00-04:00"
}

variable "maintenance_window" {
    description = "The weekly time range during which system maintenance can occur"
    type        = string
    default     = "Mon:04:00-Mon:05:00"
}

variable "deletion_protection" {
    description = "Specifies if the DB instance should have deletion protection enabled"
    type        = bool
    default     = false
}

variable "skip_final_snapshot" {
    description = "Specifies if a final DB snapshot should be created before the DB instance is deleted"
    type        = bool
    default     = true
}

