module vpc {
    source = "./network-config/vpc"
    vpc_name_tag = var.vpc_name_tag
    vpc_cidr_block = var.vpc_cidr_block
}

module "private_subnet" {
  source = "./network-config/private-subnet"
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  vpc_id = module.vpc.vpc_id
  private_subnet_name_tag = var.private_subnet_name_tag
  availability_zones = var.availability_zones
}

module "public_subnet" {
  source = "./network-config/public-subnet"
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  vpc_id = module.vpc.vpc_id
  public_subnet_name_tag = var.public_subnet_name_tag
  availability_zones = var.availability_zones
}

module "igw" {
  source = "./network-config/igw"
  vpc_id = module.vpc.vpc_id
  igw_tag = var.IGW_tag
}

module "public_route_table" {
  source = "./network-config/public-rt"
  public_route_cidr = var.public_route_cidr
  rt_tag_public = var.rt_tag_public
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  vpc_id = module.vpc.vpc_id
  igw_id = module.igw.igw_id
  public_subnets = module.public_subnet.public_subnets
}

module "private_route_table" {
  source = "./network-config/private-rt"
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  rt_tag_private = var.rt_tag_private
  vpc_id = module.vpc.vpc_id
  private_subnets = module.private_subnet.private_subnets
}