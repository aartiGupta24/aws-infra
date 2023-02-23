variable "vpc_id" {}
variable "public_route_cidr" {}
variable "igw_id" {}
variable "rt_tag_public" {}
variable "public_subnet_cidr_blocks" {}
variable "public_subnets" {}

resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = var.public_route_cidr
    gateway_id = var.igw_id
  }

  tags = {
    Name = var.rt_tag_public
  }
}

resource "aws_route_table_association" "rt_associate_public" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = element(var.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}