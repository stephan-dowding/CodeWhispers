locals {
  host = var.route_53_zone_id != "" ? aws_route53_record.app[0].fqdn : aws_instance.app.public_ip
}
output "app_address" {
  value = "http://${local.host}:8888"
}