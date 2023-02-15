resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.aws-vpc.id
    
    tags = {
        Name = var.IGW_tag
    }
}