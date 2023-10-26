module "builders" {
  source  = "../../modules/Builders"

  builder_release = local.builder_release
  builder_AdditionalArgs = local.builder_AdditionalArgs
  nimbus_release   = local.nimbus_release

  ethereum_network = local.ethereum_network
  region           = local.region
  vpc_id           = local.vpc_id

  builder_instances = local.builder_instances

  builders_instance_type = local.builders_instance_type
  root_volume_size       = local.root_volume_size
  data_volume_size       = local.data_volume_size
  ssh_key_name = local.ssh_key_name
  vpc_endpoints_security_group_id      = local.vpc_endpoints_security_group_id
}
