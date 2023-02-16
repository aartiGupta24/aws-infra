variable vpc_id {}
variable igw_tag {}

resource "aws_internet_gateway" "IGW" {
    vpc_id = var.vpc_id
    
    tags = {
        Name = var.igw_tag
    }
}

output "igw_id" { value = "${aws_internet_gateway.IGW.id}" }