variable vpc_id {}
variable rt_tag_private {}
variable private_subnets {}
variable private_subnet_cidr_blocks {}

resource "aws_route_table" "private_route_table" {
    vpc_id = var.vpc_id

    tags = {
        Name = var.rt_tag_private
    }
}

resource "aws_route_table_association" "rt_associate_private" {
    count = length(var.private_subnet_cidr_blocks)
    subnet_id = element(var.private_subnets[*].id, count.index)
    route_table_id = aws_route_table.private_route_table.id
}