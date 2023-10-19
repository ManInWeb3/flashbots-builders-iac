
data "aws_availability_zones" "available" {}


################################################################################
# VPC Module
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 5.1.2, < 6.0.0"

  name = local.name
  cidr = local.vpc_cidr

  azs                 = local.azs
  private_subnets     = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets      = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]
  # elasticache_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 8)]

  public_dedicated_network_acl   = true
  public_inbound_acl_rules       = concat(local.network_acls["default_inbound"], local.network_acls["public_inbound"])
  public_outbound_acl_rules      = concat(local.network_acls["default_outbound"], local.network_acls["public_outbound"])

  # private_dedicated_network_acl     = false

  manage_default_network_acl = true


  # Deploy only one NAT gw
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  # private_subnet_tags = {
  #   Name = "private-${local.name}"
  # }
  # public_subnet_tags = {
  #   Name = "public-${local.name}"
  # }
  tags = local.tags

}
