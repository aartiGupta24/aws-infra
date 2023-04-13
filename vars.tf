variable "region" {
  type        = string
  description = "Default Region for AWS Resources"
}

variable "profile" {
  type        = string
  description = "Environment"
}

variable "vpc_name_tag" {
  type        = string
  description = "Environment VPC Name Tag"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC IP Address Range"
}

data "aws_availability_zones" "available" {
  state = "available"
}

variable "cidr_a_b_values" {
  type    = string
  default = "10.0"
}

locals {
  availability_zones = data.aws_availability_zones.available.names
}

locals {
  cidr_c_private_subnets_values = 1
  cidr_c_public_subnets_values  = 32

  max_private_subnets = 3
  max_public_subnets  = 3
}

locals {
  private_subnet_cidr_blocks = [
    for az in local.availability_zones :
    "${var.cidr_a_b_values}.${local.cidr_c_private_subnets_values + index(local.availability_zones, az)}.0/24"
    if index(local.availability_zones, az) < local.max_private_subnets
  ]

  public_subnet_cidr_blocks = [
    for az in local.availability_zones :
    "${var.cidr_a_b_values}.${local.cidr_c_public_subnets_values + index(local.availability_zones, az)}.0/24"
    if index(local.availability_zones, az) < local.max_public_subnets
  ]
}

variable "public_subnet_name_tag" {
  type        = string
  description = "Public Subnet Name Tag"
  default     = "Public Subnet"
}

variable "private_subnet_name_tag" {
  type        = string
  description = "Private Subnet Name Tag"
  default     = "Private Subnet"
}

variable "public_route_cidr" {
  description = "Routing to an internet gateway"
}

variable "rt_tag_public" {
  type        = string
  description = "Public Route Table Tag Name"
}

variable "rt_tag_private" {
  type        = string
  description = "Private Route Table Tag Name"
}

variable "IGW_tag" {
  type        = string
  description = "Internet Gateway Tag Name"
}

// ec2 variables
variable "webapp_sg_name" {
  type        = string
  description = "Security group name for application"
}

variable "db_sg_name" {
  type        = string
  description = "Security group name for DB"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
  default     = "t2.micro"
}

variable "key_name" {
  type        = string
  description = "Name of key created using ssh "
}

variable "volume_size" {
  type        = number
  description = "Volume size"
}

variable "volume_type" {
  type        = string
  description = "Volume type"
}

variable "aws_instance_name" {
  type        = string
  description = "Name of instance"
}

variable "ami_name_pattern" {
  type = string
}

variable "db_instance_identifier" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "lb_sg_name" {
  type        = string
  description = "Security group name for Load Balancer"
}

variable "aws_lt_name" {
  type        = string
  description = "Launch Template Name"
}

variable "webapp_asg_name" {
  type        = string
  description = "Autoscaling Group Name"
}

variable "webapp_asg_min_size" {
  type        = number
  description = "Minimum number of instances in auto-scaling group"
}

variable "webapp_asg_max_size" {
  type        = number
  description = "Maximum number of instances in auto-scaling group"
}

variable "asg_desired_capacity" {
  type        = number
  description = "Number of Amazon EC2 instances that should be running in the group"
}

variable "asg_cooldown_period" {
  type        = number
  description = "Amount of time, in seconds, after a scaling activity completes before another scaling activity can start."
}

variable "scale_up_policy_name" {
  type    = string
  default = "webapp_scale_up_policy"
}

variable "scale_down_policy_name" {
  type    = string
  default = "webapp_scale_down_policy"
}

variable "scale_up_target" {
  type        = string
  description = "Target Value for Average CPU usage while scaling up"
}

variable "scale_down_target" {
  type        = string
  description = "Target Value for Average CPU usage while scaling down"
}

variable "ssl_cert_arn" {
  type        = string
  description = "SSL Certificate ARN"
}