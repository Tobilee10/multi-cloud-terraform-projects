output "vpc_id"{
    description = "The ID of the VPC"
    value       = module.networking.vpc_id
}

output "public_subnet_id"{
    description = "The ID of the public subnet"
    value       = module.networking.public_subnet_id
}

output "private_db_subnet_ids" {
    description = "The IDs of the private database subnets"
    value       = [module.networking.private_db_subnetA_id, module.networking.private_db_subnetB_id]
}

# output "private_DB_subnetA_id"{
#     description = "The ID of the private database subnetA"
#     value       = module.networking.private_DB_subnetA_id
# }

# output "private_DB_subnetB_id"{
#     description = "The ID of the private database subnetB"
#     value       = module.networking.private_DB_subnetB_id
# }

output "security_group_id"{
    description = "The ID of the security group"
    value       = module.networking.security_group_id
}

output "instance_id"{
    description = "The ID of the instance"
    value       = module.compute.instance_id
}

output "instance_public_ip"{
    description = "The public IP of the instance"
    value       = module.compute.instance_public_ip
}

# output "instance_private-ip" {
#     description = "The private IP of the instance"
#     value       = module.compute.instance_private_ip
# }

output "instance_public_dns"{
    description = "The public DNS of the instance"
    value       = module.compute.public_dns
}

output "db_instance_endpoint" {
    description = "The endpoint of the database"
    value       = module.database.db_instance_endpoint

}

output "db_address" {
    description = "The address of the database or hostname"
    value       = module.database.db_address 
}

output "db_port" {
    description = "The port of the database"
    value       = module.database.db_port
}

output "db_name" {
    description = "The name of the database"
    value       = module.database.db_name
}