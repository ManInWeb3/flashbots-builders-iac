locals {
  #* Define in locals to re-use in provider
  region = "us-east-1"
}

module "vpc_holesky" {
  source  = "../../modules/CommonInfra"

  azs      = ["us-east-1a"]
  region   = local.region

  vpc_cidr = "192.168.0.0/16"
  ethereum_network = "mainnet"
}
