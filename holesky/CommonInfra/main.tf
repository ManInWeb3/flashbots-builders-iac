module "vpc" {
  source  = "../../modules/CommonInfra"

  name = local.name
  cidr = local.vpc_cidr

  azs                 = local.azs
  public_subnets      = local.vpc_cidr
}
