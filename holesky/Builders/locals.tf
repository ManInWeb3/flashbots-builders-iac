
locals {
  ethereum_network = "holesky"

  vpc_name     = "${local.ethereum_network}-builders-vpc"
  subnets_name_preffix = "${local.ethereum_network}-builders-vpc-private-"   #* Subnet names without AZ name
  builder_instances = {
    "builder-111_333" = {
      availability_zone = "us-east-1a"
      key_id            = "dsfsdfsdfsd"
    },
    # key_222_333 = {
    #   key_id = "dsfsdfsdfsd"
    # },

  }


  # Commont Builders settings
  builder_instances_type     = "t3.micro"
  # availability_zone = element(module.vpc.azs, 0)
  # subnet_id         = element(module.vpc.private_subnets, 0)
  root_volume_size = 20
  data_volume_size = 10
  # user_data = <<-EOT
  #   #!/bin/bash
  #   echo "Hello Terraform!"
  # EOT



  tags = {
    Component   = "builder"
    Environment = local.ethereum_network
    Team        = "devops@ttt.com"
    GithubRepo = "flashbots-builders-iac"
  }

}
