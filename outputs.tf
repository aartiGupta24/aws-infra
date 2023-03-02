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

output "rds_host" {
  description = "RDS instance hostname"
  value       = aws_db_instance.webapp_pg_instance.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.webapp_pg_instance.port
  sensitive   = true
}

output "rds_user" {
  description = "RDS instance root username"
  value       = aws_db_instance.webapp_pg_instance.username
  sensitive   = true
}