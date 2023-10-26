module "vpc_holesky" {
  source  = "../../modules/CommonInfra"

  azs      = local.azs
  region   = local.region

  vpc_cidr = local.vpc_cidr
  ethereum_network = local.ethereum_network
}
