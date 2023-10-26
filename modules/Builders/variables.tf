variable "region" {
  description = "AWS region"
  type        = string
}
variable "vpc_id" {
  description = ""
  type        = string
}
variable "ethereum_network" {
  description = "Ethereum network to run nodes"
  type        = string
}
variable "builder_release" {
  description = ""
  type        = string
}
variable "builder_AdditionalArgs" {
  description = "List of additional args to pass to the builder exec cmd"
  type        = list(string)
}
variable "prysm_release" {
  description = ""
  type        = string
  default     = null
}
variable "nimbus_release" {
  description = ""
  type        = string
  default     = null
}
variable "root_volume_size" {
  description = ""
  type        = string
}
variable "data_volume_size" {
  description = ""
  type        = string
}
variable "builder_instances" {
  description = ""
  type        = map(object({
    subnet_id = string
  }))
}
variable "builders_instance_type" {
  description = ""
  type        = string
}
variable "ssh_key_name" {
  description = "If null, then ssh access will be disabled"
  type        = string
  default = null
}
variable "vpc_endpoints_security_group_id" {
  description = ""
  type        = string
}
