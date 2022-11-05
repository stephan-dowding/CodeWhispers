variable "route_53_zone_id" {
  type = string
  description = "(optional) if defined, will create a DNS record to the app in the given route53 zone"
  default = ""
}