data "aws_ami" "my_latest_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name_pattern]
  }
}

resource "aws_instance" "webapp_instance" {
  ami                  = data.aws_ami.my_latest_ami.id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  key_name             = var.key_name
  count                = 1

  subnet_id                   = module.public_subnet.public_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.webapp_sg.id]
  associate_public_ip_address = true
  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
    encrypted   = true
  }
  disable_api_termination = false
  user_data               = <<EOF
  #!/bin/bash
   
  # Redirect output to a log file
  exec &> /var/log/user-data-logs.log

  echo 'HOST=${aws_db_instance.webapp_pg_instance.address}' >> /home/ec2-user/webapp/.env   
  echo 'PORT=5432' >> /home/ec2-user/webapp/.env
  echo 'DB=${var.db_name}' >> /home/ec2-user/webapp/.env
  echo 'DB_USER=${var.db_username}' >> /home/ec2-user/webapp/.env
  echo 'PASSWORD=${var.db_password}' >> /home/ec2-user/webapp/.env
  echo 'S3_BUCKET_NAME=${aws_s3_bucket.webapp_bucket.id}' >> /home/ec2-user/webapp/.env
  echo 'AWS_S3_REGION=${var.region}' >> /home/ec2-user/webapp/.env
  echo 'DIALECT=postgres' >> /home/ec2-user/webapp/.env

  export PATH=$PATH:/home/ec2-user/.nvm/versions/node/v16.19.1/bin

  # Stop pm2 service
  pm2 kill

  cd /home/ec2-user/webapp
  /home/ec2-user/webapp/node_modules/sequelize-cli/lib/sequelize db:migrate

  sudo systemctl enable pm2-ec2-user
  sudo systemctl start pm2-ec2-user
  sudo systemctl status pm2-ec2-user
  EOF

  depends_on = [
    aws_db_instance.webapp_pg_instance
  ]
  tags = {
    Name = "${var.aws_instance_name}"
  }
}