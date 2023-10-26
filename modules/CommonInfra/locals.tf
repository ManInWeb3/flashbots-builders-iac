
locals {
  tags = {
    Component       = "builders-CommonInfra"
    EthereumNetwork = local.ethereum_network
    Team            = "devops@ttt.com"
    GithubRepo      = "flashbots-builders-iac"
  }
  name   = "${local.ethereum_network}-builders"
}
