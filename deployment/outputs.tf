locals {
  host = aws_instance.app.public_ip
}
output "app_address" {
  value = "http://${local.host}:8888"
}