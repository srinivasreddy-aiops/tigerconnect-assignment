resource "aws_route53_zone" "tigerconnect" {
  name          = "tigerconnect.com"
  force_destroy = true

  tags = {
    Name      = "tigerconnect-zone"
    Terraform = "true"
  }
}

resource "aws_route53_record" "tigerconnect-ns" {
  zone_id = aws_route53_zone.tigerconnect.zone_id
  name    = "tigerconnect.com"
  type    = "NS"
  ttl     = "300"
  records = aws_route53_zone.tigerconnect.name_servers
}

resource "aws_route53_record" "tigerconnect_alb" {
  zone_id = aws_route53_zone.tigerconnect.zone_id
  name    = "tigerconnect.com"
  type    = "A"
  ttl     = "300"
  records = [aws_alb.ecs-load-balancer.dns_name]
}
