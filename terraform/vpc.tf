module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.0"
  name = "${local.name}-vpc"
  cidr = "10.0.0.0/16"
  azs                     = data.aws_availability_zones.available.names.*
  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true
  create_igw = true
  public_subnets = ["10.0.0.0/24", "10.0.1.0/24"]
}

data "aws_availability_zones" "available" {
  state = "available"
}
