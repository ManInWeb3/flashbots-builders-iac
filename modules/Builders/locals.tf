locals {

  builders_fw_rules = [
    {
      from_port     = 30303
      to_port     = 30303
      protocol    = "tcp"
      description = "Geth P2P tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port     = 30303
      to_port     = 30303
      protocol    = "udp"
      description = "Geth P2P udp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  ingress_with_cidr_blocks = concat(local.builders_fw_rules, var.ssh_key_name != null ? [{
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH from vlad"
      cidr_blocks = "121.98.71.217/32"                                    
    }] : [] )

  egress_rules = ["all-all"]

  tags = {
    Component   = "builder"
    Environment = local.ethereum_network
    Team        = "devops@ttt.com"
    GithubRepo = "flashbots-builders-iac"
  }

}
