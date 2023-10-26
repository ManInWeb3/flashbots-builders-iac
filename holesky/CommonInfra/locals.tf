
locals {
  ###* Sometimes it's more convinient to define input values as locals, instead of variables
  ###* this could be more convinient because: you can see all the values in a shorter form in one file - kinda a config file
  region = "us-east-1"
  azs    = ["us-east-1a"]

  ethereum_network = "holesky"
  vpc_cidr = "10.0.0.0/16"
}
