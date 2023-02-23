output "vpc_id" {
  description = "Virtual Private Cloud ID"
  value       = module.vpc.vpc_id
}

output "ig_id" {
  value       = module.igw.igw_id
  description = "Internet Gateway ID"
}

output "private_subnets" {
  description = "Private Subnets Created"
  value       = module.private_subnet.private_subnets
}

output "public_subnets" {
  description = "Public Subnets Created"
  value       = module.public_subnet.public_subnets
}
