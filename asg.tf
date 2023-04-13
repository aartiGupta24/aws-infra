resource "aws_autoscaling_group" "webapp_asg" {
  name = var.webapp_asg_name

  max_size         = var.webapp_asg_max_size
  min_size         = var.webapp_asg_min_size
  desired_capacity = var.asg_desired_capacity
  default_cooldown = var.asg_cooldown_period

  health_check_grace_period = 300
  health_check_type         = "EC2"
  vpc_zone_identifier       = [for subnet in module.public_subnet.public_subnets : subnet.id]

  launch_template {
    id      = aws_launch_template.webapp_ec2_lt.id
    version = aws_launch_template.webapp_ec2_lt.latest_version
  }

  tag {
    key                 = "Application"
    value               = "webapp"
    propagate_at_launch = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  target_group_arns = [aws_lb_target_group.webapp_lb_tg.arn]

  depends_on = [
    aws_launch_template.webapp_ec2_lt
  ]
}

resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "scale_up_policy"
  policy_type            = "SimpleScaling"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
  cooldown               = 60
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization_metric" {
  alarm_name          = "high_cpu_utilization_metric"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = var.scale_up_target

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_asg.name
  }

  alarm_description = "Alarm Metric to monitor CPU Utilization when it exceeds 2%"
  alarm_actions     = [aws_autoscaling_policy.scale_up_policy.arn]
}

resource "aws_autoscaling_policy" "scale_down_policy" {
  name                   = "scale_down_policy"
  policy_type            = "SimpleScaling"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
  cooldown               = 60
}

resource "aws_cloudwatch_metric_alarm" "low_cpu_utilization_metric" {
  alarm_name          = "low_cpu_utilization_metric"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = var.scale_down_target

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_asg.name
  }

  alarm_description = "Alarm Metric to monitor CPU Utilization when it goes below 1%"
  alarm_actions     = [aws_autoscaling_policy.scale_down_policy.arn]
}