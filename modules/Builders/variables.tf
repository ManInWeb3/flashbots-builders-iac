variable "region" {
  description = "AWS region"
  type        = string
}
variable "vpc_id" {
  description = "VPC id to deploy builders into"
  type        = string
}
variable "ethereum_network" {
  description = "Ethereum network to run nodes"
  type        = string
}
variable "root_volume_size" {
  description = "Size of the instances' root volume"
  type        = string
}
variable "data_volume_size" {
  description = "Size of the data volume attached to the instances"
  type        = string
}
variable "builder_instances" {
  description = "List of settings for each builder instance"
  type        = map(object({
    subnet_id              = string        #* Subnet id to deploy the instance
    builder_AdditionalArgs = list(string)  #* List of additional args to pass to BUILDER cmd on the instance
    builder_release        = string        #* BUILDER release name to deploy on the instance
    nimbus_release         = string        #* NIMBUS release name to deploy on the instance
  }))
}
variable "builders_instance_type" {
  description = "EC2 type of all builder instances"
  type        = string
}
variable "ssh_key_name" {
  description = "SSH key name to connect to the instanse. If null, then ssh access will be disabled. SHOULD be used only for rsync data"
  type        = string
  default     = null
}
variable "vpc_endpoints_security_group_id" {
  description = "Security group of the VPC endpoints to setup Session manager"
  type        = string
}
