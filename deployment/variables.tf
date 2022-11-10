variable "route_53_zone_id" {
  type = string
  description = "(optional) if defined, will create a DNS record to the app in the given route53 zone"
  default = ""
}

variable "public_hostname" {
  type = string
  description = "(optional) if defined, will override the hostname the app uses for itself. Otherwise, will default to an IP"
  default = ""
}