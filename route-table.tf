resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.aws-vpc.id
    
    route {
        cidr_block = var.public_route_cidr
        gateway_id = aws_internet_gateway.IGW.id
    }
    
    tags = {
        Name = var.rt_tag_public
    }
}

resource "aws_route_table_association" "rt_associate_public" {
    count = length(var.public_subnet_cidr_blocks)
    subnet_id = element(aws_subnet.public_subnets[*].id, count.index)
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.aws-vpc.id

    tags = {
        Name = var.rt_tag_private
    }
}

resource "aws_route_table_association" "rt_associate_private" {
    count = length(var.private_subnet_cidr_blocks)
    subnet_id = element(aws_subnet.private_subnets[*].id, count.index)
    route_table_id = aws_route_table.private_route_table.id
}