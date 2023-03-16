data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "webapp_route" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = data.aws_route53_zone.main.name
  type    = "A"
  ttl     = "60"
  records = [aws_instance.webapp_instance[0].public_ip]
}