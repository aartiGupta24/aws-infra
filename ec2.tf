data "aws_ami" "my_latest_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name_pattern]
  }
}

resource "aws_security_group" "webapp_sg" {
  name   = var.sg_name
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [var.public_route_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.public_route_cidr]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public_route_cidr]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.public_route_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public_route_cidr]
  }

  tags = {
    Name = "${var.sg_name}"
  }
}

resource "aws_instance" "webapp_instance" {
  ami           = data.aws_ami.my_latest_ami.id
  instance_type = var.instance_type
  key_name      = var.key_name
  count         = 1

  subnet_id                   = module.public_subnet.public_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.webapp_sg.id]
  associate_public_ip_address = true
  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
    encrypted   = true
  }
  disable_api_termination = true

  tags = {
    Name = "${var.aws_instance_name}"
  }
}