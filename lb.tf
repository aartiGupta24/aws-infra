resource "aws_lb" "webapp_lb" {
  name               = "webapp-lb"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [for subnet in module.public_subnet.public_subnets : subnet.id]

  tags = {
    Application = "webapp"
  }
}

resource "aws_lb_target_group" "webapp_lb_tg" {
  name        = "webapp-lb-tg"
  target_type = "instance"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    protocol            = "HTTP"
    port                = 3000
    path                = "/healthz"
    matcher             = "200-299"
    interval            = 30 # default
    timeout             = 5  # default = 6
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.webapp_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp_lb_tg.arn
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.webapp_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:999859291911:certificate/1c2b90ef-17a1-495d-8fc8-86fcb246565d"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp_lb_tg.arn
  }
}