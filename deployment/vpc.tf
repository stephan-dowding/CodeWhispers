module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "codewhispers"
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a"]
  private_subnets = []
  public_subnets  = ["10.0.101.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false
}