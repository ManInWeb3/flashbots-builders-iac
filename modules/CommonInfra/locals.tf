
locals {
  tags = {
    Component       = "builders-CommonInfra"
    EthereumNetwork = var.ethereum_network
    Team            = "devops@ttt.com"
    GithubRepo      = "flashbots-builders-iac"
  }
  name   = "${var.ethereum_network}-builders"
}
