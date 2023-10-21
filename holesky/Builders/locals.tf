
locals {

  ethereum_network = "holesky"

  # name   = "${local.environment}-builders-vpc"

  vpc_name     = "${local.environment}-builders-vpc"
  subnet_names = [
    "${local.environment}-builders-vpc-private-us-east-1a",
  ]

  # Commont EC2 settings
  instance_type     = "t3.micro"
  availability_zone = element(module.vpc.azs, 0)
  subnet_id         = element(module.vpc.private_subnets, 0)
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 50
      tags = {
        Name = "my-root-block"
      }
    }
  ]
  root_volume_size = 20
  data_volume_size = 10

  ec2_instances = {
    key_111_333 = {
      key_id = "dsfsdfsdfsd"
    }
  }



  tags = {
    Component   = "builder"
    Environment = local.environment
    Team        = "devops@ttt.com"
    GithubRepo = "flashbots-builders-infra"
  }

}
