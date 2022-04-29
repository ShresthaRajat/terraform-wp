# Create VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.VPC_CIDR
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.SUBNET_1_CIDR
  map_public_ip_on_launch = "true" # public subnet
  availability_zone       = var.AZ1
}

resource "aws_route_table" "public-crt" {
  vpc_id = aws_vpc.vpc.id

  route {
    # associated subnet can reach everywhere
    cidr_block = "0.0.0.0/0"
    # CRT uses this IGW to reach internet
    gateway_id = aws_internet_gateway.igw.id
  }

}

# Associating route tabe to public subnet
resource "aws_route_table_association" "crta-public-subnet-1" {
  subnet_id      = aws_subnet.subnet-public-1.id
  route_table_id = aws_route_table.public-crt.id
}

resource "aws_security_group" "wordpress-sec-group" {
  name        = "wordpress-sec-group"
  description = "Simple wordpress security group with ssh, http and, https enabled"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Default Wordpress SG"
  }
}

# # Create Private subnet for RDS
# resource "aws_subnet" "subnet-private-1" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = var.SUBNET_2_CIDR
#   map_public_ip_on_launch = "false" //it makes private subnet
#   availability_zone       = var.AZ2
# }
#
# # Create second Private subnet for RDS
# resource "aws_subnet" "subnet-private-2" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = var.SUBNET_3_CIDR
#   map_public_ip_on_launch = "false" //it makes private subnet
#   availability_zone       = var.AZ3
# }