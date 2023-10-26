variable "region" {
  description = "AWS region"
  type        = string
}

variable "azs" {
  description = "AWS region's azs"
  type        = list
}
variable "ethereum_network" {
  description = "Ethereum network to run nodes"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR to use to create VPC"
  type        = string
}
