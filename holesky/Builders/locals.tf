
#* DEPENDENCIES:
#*  1. Secret key created and specified ...


locals {
  region = "us-east-1"
  ethereum_network = "holesky"

  # vpc_name     = "${local.ethereum_network}-builders-vpc"
  # subnets_name_preffix = "${local.ethereum_network}-builders-vpc-private-"   #* Subnets name without AZ name
  builder_instances = {
    "builder-111_333" = {
      # availability_zone = "us-east-1a"
      subnet_id  = "subnet-0b8d187f0c60263f5"
      key_id            = "111dsfsdfsdfsd333"
    },
    # key_222_333 = {
    #   key_id = "dsfsdfsdfsd"
    # },

  }
  # Security groups
  ssm_security_group_id      = "sg-039ec2c1a094dfb1d"
  builders_security_group_id = ["sg-0b585ec7a7c290e96"]

  # Commont Builders settings
  builders_instance_type     = "t3.micro"
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
