variable private_subnet_cidr_blocks {}
variable vpc_id {}
variable availability_zones {}
variable private_subnet_name_tag {}

resource "aws_subnet" "private_subnets" {
    count = length(var.private_subnet_cidr_blocks)
    vpc_id = var.vpc_id
    cidr_block = element(var.private_subnet_cidr_blocks, count.index)
    availability_zone = element(var.availability_zones, count.index)
    
    tags = {
        Name = "${var.private_subnet_name_tag} ${count.index + 1}"
    }
}

output "private_subnets" { value = "${aws_subnet.private_subnets}" }