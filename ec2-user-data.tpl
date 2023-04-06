#!/bin/bash
  
# Redirect output to a log file
exec &> /var/log/user-data-logs.log

echo 'HOST=${HOST}' >> /home/ec2-user/webapp/.env   
echo 'PORT=${PORT}' >> /home/ec2-user/webapp/.env
echo 'DB=${DB}' >> /home/ec2-user/webapp/.env
echo 'DB_USER=${DB_USER}' >> /home/ec2-user/webapp/.env
echo 'PASSWORD=${PASSWORD}' >> /home/ec2-user/webapp/.env
echo 'S3_BUCKET_NAME=${S3_BUCKET_NAME}' >> /home/ec2-user/webapp/.env
echo 'AWS_S3_REGION=${AWS_S3_REGION}' >> /home/ec2-user/webapp/.env
echo 'DIALECT=${DIALECT}' >> /home/ec2-user/webapp/.env

export PATH=$PATH:/home/ec2-user/.nvm/versions/node/v16.20.0/bin

# Stop pm2 service
pm2 kill

cd /home/ec2-user/webapp
/home/ec2-user/webapp/node_modules/sequelize-cli/lib/sequelize db:migrate

sudo systemctl enable pm2-ec2-user
sudo systemctl start pm2-ec2-user
sudo systemctl status pm2-ec2-user

# Configuring cloudwatch-agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-a fetch-config \
-m ec2 \
-c file:/opt/cloudwatch_config.json \
-s

# To enable cloudwatch-agent on reboot
sudo systemctl enable amazon-cloudwatch-agent 

sudo systemctl start amazon-cloudwatch-agent