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

  cd /home/ec2-user/webapp/config
  mv config.js config_bak.js

  echo "export default {
    host: \"${aws_db_instance.webapp_pg_instance.address}\",
    port: \"5432\",
    username: \"${var.db_username}\",
    password: \"${var.db_password}\",
    database: \"${var.db_name}\",
    dialect: \"postgres\",
    regionS3: \"${var.region}\",
    s3bucketName: \"${aws_s3_bucket.webapp_bucket.id}\"
  };" > /home/ec2-user/webapp/config/config.js

  echo "Installing Node.js and npm"
  yum update -y	
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
  . /home/ec2-user/.nvm/nvm.sh
  nvm install 16

  # Install pm2
  /home/ec2-user/.nvm/versions/node/v16.19.1/bin/npm install -g pm2@latest

  # Stop pm2 service
  pm2 kill

  # Install Sequelize CLI globally
  npm install -g sequelize-cli

  cd /home/ec2-user/webapp
  /home/ec2-user/.nvm/versions/node/v16.19.1/bin/sequelize-cli db:migrate
  /home/ec2-user/.nvm/versions/node/v16.19.1/bin/pm2 startup
  sudo env PATH=$PATH:/home/ec2-user/.nvm/versions/node/v16.19.1/bin /home/ec2-user/.nvm/versions/node/v16.19.1/lib/node_modules/pm2/bin/pm2 startup systemd -u ec2-user --hp /home/ec2-user

  # Start pm2 service
  su ec2-user
  /home/ec2-user/.nvm/versions/node/v16.19.1/bin/pm2 start server.js
  /home/ec2-user/.nvm/versions/node/v16.19.1/bin/pm2 save
  EOF

  depends_on = [
    aws_db_instance.webapp_pg_instance
  ]
  tags = {
    Name = "${var.aws_instance_name}"
  }
}