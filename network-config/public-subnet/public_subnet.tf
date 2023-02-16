variable public_subnet_cidr_blocks {}
variable vpc_id {}
variable availability_zones {}
variable public_subnet_name_tag {}

resource "aws_subnet" "public_subnets" {
    count = length(var.public_subnet_cidr_blocks)
    vpc_id = var.vpc_id
    cidr_block = element("${var.public_subnet_cidr_blocks}", count.index)
    availability_zone = element(var.availability_zones, count.index)
    
    tags = {
        Name = "${var.public_subnet_name_tag} ${count.index + 1}"
    }
}

output "public_subnets" { value = "${aws_subnet.public_subnets}" }