resource "aws_security_group" "webapp_sg" {
  name   = var.webapp_sg_name
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
    Name = "${var.webapp_sg_name}"
  }
}

resource "aws_security_group" "db_sg" {

  name   = var.db_sg_name
  vpc_id = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public_route_cidr]
  }

  tags = {
    Name = var.db_sg_name
  }
}

// To allow TCP traffic for PostgreSQL
resource "aws_security_group_rule" "db_from_app" {
  security_group_id        = aws_security_group.db_sg.id
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.webapp_sg.id
}