variable vpc_name_tag {}
variable vpc_cidr_block {}

resource "aws_vpc" "aws-vpc" {
    cidr_block = var.vpc_cidr_block
    
    tags = {
        Name = var.vpc_name_tag
    }
}

output "vpc_id" { value = "${aws_vpc.aws-vpc.id}" }