
locals {
  ###* Sometimes it's more convinient to define input values as locals, instead of variables
  ###* this could be more convinient because: you can see all the values in a shorter form in one file - kinda a config file

  ethereum_network = "holesky"
  vpc_cidr = "10.0.0.0/16"

  network_acls = {
    # default_inbound = [
    #   {
    #     rule_number = 900
    #     rule_action = "allow"
    #     from_port   = 1024
    #     to_port     = 65535
    #     protocol    = "tcp"
    #     cidr_block  = "0.0.0.0/0"
    #   },
    # ]
    # default_outbound = [
    #   {
    #     rule_number = 900
    #     rule_action = "allow"
    #     from_port   = 32768
    #     to_port     = 65535
    #     protocol    = "tcp"
    #     cidr_block  = "0.0.0.0/0"
    #   },
    # ]
    public_inbound = [
      # {
      #   rule_number = 120
      #   rule_action = "allow"
      #   from_port   = 22
      #   to_port     = 22
      #   protocol    = "tcp"
      #   cidr_block  = "0.0.0.0/0"
      # },
      {
        rule_number = 10
        rule_action = "allow"
        from_port   = 30303
        to_port     = 30303
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 11
        rule_action = "allow"
        from_port   = 30303
        to_port     = 30303
        protocol    = "udp"
        cidr_block  = "0.0.0.0/0"
      },
    ]
    public_outbound = [
      {
        rule_number = 10
        rule_action = "allow"
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 11
        rule_action = "allow"
        from_port   = 0
        to_port     = 65535
        protocol    = "udp"
        cidr_block  = "0.0.0.0/0"
      },
    ]
  }

  tags = {
    Component       = "builders-CommonInfra"
    EthereumNetwork = local.ethereum_network
    Team            = "devops@ttt.com"
    GithubRepo      = "flashbots-builders-iac"
  }

  # Calculated vars
  name   = "${local.ethereum_network}-builders"
}
