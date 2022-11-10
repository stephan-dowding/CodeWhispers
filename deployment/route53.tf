resource "aws_route53_record" "app" {
  count = var.route_53_zone_id != "" ? 1 : 0
  name    = "codewhispers"
  type    = "A"
  zone_id = var.route_53_zone_id
  records = [aws_instance.app.public_ip]
  ttl = 60
}