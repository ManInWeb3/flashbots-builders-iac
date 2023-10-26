locals {
  tags = {
    Component   = "builder"
    Environment = local.ethereum_network
    Team        = "devops@ttt.com"
    GithubRepo = "flashbots-builders-iac"
  }

}
