# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

# Subnets
resource "aws_subnet" "sn_pub_az1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.az1
  cidr_block              = var.subnet_az1
  map_public_ip_on_launch = true
}

resource "aws_subnet" "sn_pub_az1b" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.az2
  cidr_block              = var.subnet_az2
  map_public_ip_on_launch = true
}

# Route Table
resource "aws_route_table" "rt_pub" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Route Table Association
resource "aws_route_table_association" "rt_pub_sn_pub_az1a" {
  subnet_id      = aws_subnet.sn_pub_az1a.id
  route_table_id = aws_route_table.rt_pub.id
}

resource "aws_route_table_association" "rt_pub_sn_pub_az1b" {
  subnet_id      = aws_subnet.sn_pub_az1b.id
  route_table_id = aws_route_table.rt_pub.id
}

# Security Group
resource "aws_security_group" "vpc_sg_pub" {
  vpc_id = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
