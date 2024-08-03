# Security group for frontend ec2
resource "aws_security_group" "frontend_sg" {
  name        = "Frontend_sg"
  vpc_id      = var.vpc_id
  description = "Allow http/https, ssh inbound traffic and all outbound traffic"
  tags = {
    Name = "Frontend_sg"
  }
}

# Add Inbound and outbound rules
# Allow all traffic for testing
resource "aws_vpc_security_group_ingress_rule" "allow_all_test" {
  security_group_id = aws_security_group.frontend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
}

# resource "aws_vpc_security_group_ingress_rule" "allow_http" {
#   security_group_id = aws_security_group.frontend_sg.id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 80
#   ip_protocol       = "tcp"
#   to_port           = 80
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
#   security_group_id = aws_security_group.frontend_sg.id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 22
#   ip_protocol       = "tcp"
#   to_port           = 22
# }

# Outbound rule
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.frontend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Create security group for backend ec2
resource "aws_security_group" "backend_sg" {
  name        = "Backend_sg"
  vpc_id      = var.vpc_id
  description = "enable mysql access on port 3306 from frontend-sg"
  tags = {
    Name = "Backend_sg"
  }

}

resource "aws_vpc_security_group_ingress_rule" "allow_all_frontend" {
  security_group_id = aws_security_group.backend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
}

# Just for testing the connection with frontend
# resource "aws_vpc_security_group_ingress_rule" "allow_ssh_frontend" {
#   security_group_id = aws_security_group.backend_sg.id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 22
#   ip_protocol       = "tcp"
#   to_port           = 22
# }

# Required
# resource "aws_vpc_security_group_ingress_rule" "mysql_access" {
#   security_group_id = aws_security_group.backend_sg.id
#   description       = "mysql access"
#   from_port         = 3306
#   to_port           = 3306
#   ip_protocol       = "tcp"
#   cidr_ipv4         = "0.0.0.0/0"
# }

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.backend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1" # semantically equivalent to all ports
}
