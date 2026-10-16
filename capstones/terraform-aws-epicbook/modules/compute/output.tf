output "instance_id"{
    description = "The ID of the instance"
    value       = aws_instance.eb_instance.id
}

output "instance_public_ip"{
    description = "The public IP of the instance"
    value       = aws_instance.eb_instance.public_ip
}

output "public_dns"{
    description = "The public DNS of the instance"
    value       = aws_instance.eb_instance.public_dns
}