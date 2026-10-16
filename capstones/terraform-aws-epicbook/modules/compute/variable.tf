variable "ami_id" {
    description = "The AMI ID for the instance"
    type        = string
}
variable "instance_type" {
    description = "The type of instance to create"
    type        = string
}

variable "public_subnet_id" {
    description = "The public subnet ID for the instance"
    type        = string
}

variable "security_group_id" {
  description = "The ID of the security group"
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




## Database

variable "db_address" {
  type        = string
  description = "RDS endpoint address"
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}