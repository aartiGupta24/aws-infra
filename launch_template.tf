data "aws_ami" "my_latest_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name_pattern]
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/ec2-user-data.tpl")
  vars = {
    HOST           = "${aws_db_instance.webapp_pg_instance.address}"
    DB             = "${var.db_name}"
    PORT           = "5432"
    DIALECT        = "postgres"
    DB_USER        = "${var.db_username}"
    PASSWORD       = "${var.db_password}"
    AWS_S3_REGION  = "${var.region}"
    S3_BUCKET_NAME = "${aws_s3_bucket.webapp_bucket.id}"
  }
}

resource "aws_launch_template" "webapp_ec2_lt" {
  name = var.aws_lt_name

  image_id      = data.aws_ami.my_latest_ami.id
  instance_type = var.instance_type
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }
  key_name = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.webapp_sg.id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.volume_size
      volume_type = var.volume_type
      encrypted   = true
    }
  }
  disable_api_termination = false

  user_data = base64encode(data.template_file.user_data.rendered)

  tags = {
    Name = "${var.aws_lt_name}"
  }
}