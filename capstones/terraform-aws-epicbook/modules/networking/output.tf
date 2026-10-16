
output "vpc_id" {
    description = "The ID of the VPC"
    value = aws_vpc.eb-vpc.id
}

output "public_subnet_id" {
    description = "The ID of the public subnet"
    value = aws_subnet.eb-public-subnet.id
}

# output "private_db_subnet_ids" {
#     description = "The IDs of the private database subnets"
#     value = [
#         aws_subnet.eb-private-db-subnetA.id,
#         aws_subnet.eb-private-db-subnetB.id
#     ]
# }

output "private_db_subnetA_id" {
    description = "The ID of the private database subnet A"
    value = aws_subnet.eb-private-db-subnetA.id
}

output "private_db_subnetB_id" {
    description = "The ID of the private database subnet B"
    value = aws_subnet.eb-private-db-subnetB.id
}

output "intenet_gateway_id" {
    description = "The ID of the internet gateway"
    value = aws_internet_gateway.eb-igw.id
}

output "public_route_table_id" {
    description = "The ID of the public route table"
    value = aws_route_table.eb-public-rt.id
}

output "security_group_id" {
    description = "The ID of the public security group"
    value = {
        web = aws_security_group.eb_web_sg.id
        db  = aws_security_group.eb_db_sg.id
    }
}


