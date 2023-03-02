# Create an RDS parameter group
resource "aws_db_parameter_group" "custom_rds_param_group" {
  name_prefix = "custom-rds-param-group-"
  family      = "postgres14"
  description = "Custom parameter group for postgres 14 database"
}

# Create a subnet group for the RDS instance
resource "aws_db_subnet_group" "private_subnet_group" {
  name       = "private-subnet-group"
  subnet_ids = [for subnet in module.private_subnet.private_subnets : subnet.id] // module.private_subnet.private_subnets[0].id
}

# Create an RDS instance for PostgreSQL
resource "aws_db_instance" "webapp_pg_instance" {
  identifier             = var.db_instance_identifier
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  allocated_storage      = 20
  storage_type           = "gp2"
  engine_version         = "14.4"
  parameter_group_name   = aws_db_parameter_group.custom_rds_param_group.name
  vpc_security_group_ids = ["${aws_security_group.db_sg.id}"]
  skip_final_snapshot    = true

  multi_az             = false
  db_subnet_group_name = aws_db_subnet_group.private_subnet_group.name
  publicly_accessible  = false
  db_name              = var.db_name
}