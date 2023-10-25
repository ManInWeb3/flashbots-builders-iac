
#* DEPENDENCIES:
#*  1. Secret key created and specified ...
#*  2. Builder release specified


locals {
  #* BUILDER release to deploy
  #* For example: v1.13.2-4844.dev5.c786eb74f
  builder_release ="v1.13.2-4844.dev5.c786eb74f"

  ethereum_network = "holesky"
  region           = "us-east-1"
  vpc_id           = "vpc-0aa923abc5e9486b0"

  builder_instances = {
    "builder-111_333" = {
      subnet_id  = "subnet-0b8d187f0c60263f5"
      key_id            = "111dsfsdfsdfsd333"
    },
    # key_222_333 = {
    #   key_id = "dsfsdfsdfsd"
    # },

  }

  # Commont Builders settings
  builders_instance_type = "t3.large"  #"t3.micro"
  root_volume_size       = 20
  data_volume_size       = 10

  # Security groups
  ssm_security_group_id      = "sg-039ec2c1a094dfb1d"
  builders_security_group_id = ["sg-0b585ec7a7c290e96"]

  tags = {
    Component   = "builder"
    Environment = local.ethereum_network
    Team        = "devops@ttt.com"
    GithubRepo = "flashbots-builders-iac"
  }

}
