
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  #default     = "10.0.0.0/16"
}


variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type        = string
  #default     = "10.0.1.0/24"
}   

variable "private_db_subnetA_cidr" {
  description = "The CIDR block for the private database subnetA"
  type        = string
  #default     = "10.0.2.0/29"   
}

variable "private_db_subnetB_cidr" {
  description = "The CIDR block for the private database subnetB"
  type        = string
  #default     = "10.0.3.0/29"   
}

variable "availability_zones" {
  description = "The availability zones for the subnets"
  type        = list(string)
  #default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "security_group_names" {
  description = "The name of the security group"
  type        = map(string)
  default     = {
    web = "eb-web-sg"
    db  = "eb-db-sg"
  }
}

# variable "tags" {
#   description = "A map of tags to assign to the resources"
#   type        = map(string)
#   default     = {
#     Environment = "dev"
#     Project     = "epicbook"
#   }
# }
