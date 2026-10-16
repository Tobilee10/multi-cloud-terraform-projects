
resource "aws_vpc" "eb-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "eb-vpc"
  }
}


resource "aws_subnet" "eb-public-subnet" {
  vpc_id     = aws_vpc.eb-vpc.id
  cidr_block = var.public_subnet_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "eb-public-subnet"
  }
}

resource "aws_subnet" "eb-private-db-subnetA" {
  vpc_id     = aws_vpc.eb-vpc.id
  cidr_block = var.private_db_subnetA_cidr
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "eb-private-db-subnetA"
  }
}

resource "aws_subnet" "eb-private-db-subnetB" {
  vpc_id     = aws_vpc.eb-vpc.id
  cidr_block = var.private_db_subnetB_cidr
  availability_zone       = var.availability_zones[2]
  map_public_ip_on_launch = false

  tags = {
    Name = "eb-private-db-subnetB"
  }
}


resource "aws_internet_gateway" "eb-igw" {
  vpc_id = aws_vpc.eb-vpc.id

  tags = {
    Name = "eb-igw"
  }
}

resource "aws_route_table" "eb-public-rt" {
  vpc_id = aws_vpc.eb-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eb-igw.id
  }

   tags = {
    Name = "eb-public-rt   "
  }
}

resource "aws_route_table_association" "eb-public-rt-assoc" {
  subnet_id      = aws_subnet.eb-public-subnet.id
  route_table_id = aws_route_table.eb-public-rt.id
}



resource "aws_security_group" "eb_web_sg" { 
  name        = var.security_group_names["web"]
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.eb-vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public_subnet_cidr]
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
    Name = "eb-web-sg"
  }
}


resource "aws_security_group" "eb_db_sg" { 
  name        = var.security_group_names["db"]
  description = "Allow MySQL"
  vpc_id      = aws_vpc.eb-vpc.id


  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.public_subnet_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eb-db-sg"
  }
}