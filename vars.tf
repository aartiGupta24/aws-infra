variable aws_version {
    default = ">= 4.0"
}

variable "region" {
    type = string
    description = "Default Region for AWS Resources"
}

variable "profile" {
    type = string
    description = "Environment"
}

variable "vpc_name_tag" {
    type = string
    description = "Environment VPC Name Tag"
}

variable "vpc_cidr_block" {
    type = string
    description = "VPC IP Address Range"
}

variable "public_subnet_cidr_blocks" {
    type = list(string)
    description = "Public Subnet CIDR block values"
}
 
variable "private_subnet_cidr_blocks" {
    type = list(string)
    description = "Private Subnet CIDR block values"
}

variable "availability_zones" {
    type = list(string)
    description = "Availability Zones"
}

variable "public_route_cidr" {
    description = "Routing to an internet gateway"
}

variable "rt_tag_public" {
    type = string
    description = "Public Route Table Tag Name"
}

variable "rt_tag_private" {
    type = string
    description = "Private Route Table Tag Name"
}

variable "IGW_tag" {
    type = string
    description = "Internet Gateway Tag Name"
}