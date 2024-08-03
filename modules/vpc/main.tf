# Public VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default" # It ensures that EC2 instances launched in this VPC use the EC2 instance tenancy attribute specified when the EC2 instance is launched
  enable_dns_hostnames = true
  enable_dns_support   = true # Not required becoz by default it is true

  tags = {
    Name = "public-vpc"
  }
}

# Create Internet gateway and attach it to VPC
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "project-igw"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true # Specify true to indicate that instances launched into the subnet should be assigned a public IP address. Default is false

  tags = {
    Name = "public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true # Becoz it is a private subnet we dont need to create public ip to access it (By default it is false)

  tags = {
    Name = "private-subnet"
  }
}

# Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id # Internet gateway id 
  }

  tags = {
    Name = "public-rt"
  }
}

# Attach the public subnet to the route table so that it can access the internet
resource "aws_route_table_association" "public_subnet_route_table" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id # Internet gateway id 
  }

  tags = {
    Name = "private-rt"
  }
}

# Attach the public subnet to the route table so that it can access the internet
resource "aws_route_table_association" "private_subnet_route_table" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}
