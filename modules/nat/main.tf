# Allocate elastic ip. this eip will be used for the nat-gateway in the public subnet
resource "aws_eip" "eip_nat_public" {
  domain = "vpc"

  tags = {
    Name = "public-nat-eip"
  }
}

# create nat gateway in public subnet
resource "aws_nat_gateway" "nat_public_subnet" {
  allocation_id = aws_eip.eip_nat_public.id
  subnet_id     = var.public_subnet_id
  tags = {
    Name = "private-nat"
  }

  depends_on = [var.internet_gateway_id]

}

# Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_public_subnet.id
  }

  tags = {
    Name = "private-rt"
  }
}

# Attach the private subnet to the route table so that it can access the internet
resource "aws_route_table_association" "private_subnet_route_table" {
  subnet_id      = var.private_subnet_id
  route_table_id = aws_route_table.private_route_table.id
}
