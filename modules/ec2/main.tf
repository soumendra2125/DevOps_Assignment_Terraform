resource "aws_instance" "frontend" {
  ami                    = "ami-04a81a99f5ec58529"
  instance_type          = "t2.micro"
  key_name               = "laptop-keys"
  monitoring             = true
  vpc_security_group_ids = [var.frontend_sg_id]
  subnet_id              = var.public_subnet_id
  tags = {
    Name = "Fontend"
  }
}

resource "aws_instance" "backend" {
  ami                    = "ami-04a81a99f5ec58529"
  instance_type          = "t2.micro"
  key_name               = "laptop-keys"
  monitoring             = true
  vpc_security_group_ids = [var.backend_sg_id]
  subnet_id              = var.private_subnet_id
  tags = {
    Name = "Backend"
  }
}
