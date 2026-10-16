terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "rubi-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true


  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "rubi-public-snet" {
  vpc_id                  = aws_vpc.rubi-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-snet"
  }
}

resource "aws_subnet" "rubi-private-snet" {
  vpc_id                  = aws_vpc.rubi-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-snet"
  }
}


resource "aws_internet_gateway" "rubi-igw" {
  vpc_id = aws_vpc.rubi-vpc.id

  tags = {
    Name = "rubi-igw"
  }
}

# resource "aws_internet_gateway_attachment" "rubi-igw-attachment" {
#   internet_gateway_id = aws_internet_gateway.rubi-igw.id
#   vpc_id              = aws_vpc.rubi-vpc.id
# }


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.rubi-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rubi-igw.id
  }

  tags = {
    Name = "Terraform-Public-RT"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.rubi-public-snet.id
  route_table_id = aws_route_table.public_rt.id
}




resource "aws_security_group" "web_sg" {
  name        = "Terraform-Web-SG"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.rubi-vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform-Web-SG"
  }
}


resource "aws_key_pair" "rubi-deployer" {
  key_name   = "terraform-aws-vm-key"
  public_key = file("/home/rubi-cloud/.ssh/terraform-aws-vm-key.pub")
}



data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.rubi-public-snet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  key_name                    = aws_key_pair.rubi-deployer.key_name
  associate_public_ip_address = true

  tags = {
    Name = "Terraform-AWS-VM"
  }
}


output "public_ip_address" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web.public_ip
}

