resource "aws_key_pair" "eb-deployer" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}


resource "aws_instance" "eb_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = aws_key_pair.eb-deployer.key_name
  associate_public_ip_address = true
  #user_data                   = var.user_data
  # Pass rendered template into the module variable
  user_data = templatefile("${path.module}/templates/user_data.tftpl", {
      db_endpoint = var.db_address
      db_host    = var.db_address   
      db_username = var.db_username
      db_user     = var.db_username
      db_password = var.db_password
      db_name     = var.db_name
  })
  tags = {
    Name = "eb-instance"
  }
}

