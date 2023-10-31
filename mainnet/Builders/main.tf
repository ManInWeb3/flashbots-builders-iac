locals{
  #* BUILDERs common settings
  region = "us-east-1"
  ethereum_network = "mainnet"    #* Ethereum network to conect the builders
  ssh_key_name           = null #"vlad"    # Only to rsync data, to access instance's console use Session manager
  builders_instance_type = "t3.micro"  #"t3.medium"             #
  root_volume_size       = 20
  data_volume_size       = 10
  vpc_id                 = "vpc-XXXXX"
  vpc_endpoints_security_group_id = "sg-XXXXX"   # VPC Endpoint security group, created in common infra module

  #* BUILDER cli's release name to deploy
  #! This value can be overwritten with instance's override_builder_release
  #* To deploy a new builder release, change this value.
  builder_release = "v1.13.2-4844.dev5.newrelease"  #* eg. v1.13.2-4844.dev5.c786eb74f

  #* BUILDERs' command already have the following arguments auto configured:
  #* --${ethereum_network}
  #* --authrpc.jwtsecret=$BUILDER_JWT_PATH
  #* --datadir=$DATA_DIR/${ethereum_network}/$(basename $BUILDER_BIN)
  #* --log.file=$DATA_DIR/${ethereum_network}/$(basename $BUILDER_BIN)_$BUILDER_RELEASE.log
  #* If you need to add more arguments, add them in builder_AdditionalArgs list or override_builder_AdditionalArgs in the builder map
  #! This value can be overwritten with instance's override_builder_AdditionalArgs
  builder_AdditionalArgs = [
    "--http --http.api eth,net,engine,admin",
    "--builder",
    "--builder.local_relay",
    "--builder.beacon_endpoints=http://127.0.0.1:3500",
    "--metrics"
  ]

  #* NIMBUS release name to deploy
  #! This value can be overwritten with instance's override_nimbus_release
  nimbus_release  = "v23.9.1"

  #* BUILDERs' map defining each instance
  #*   override_... args could be used to do canary releases
  builder_instances = {
      #* Example builder
      #* "builder_name" = { - (REQUIRED) Name of the instance and secret name($BUILDER_TX_SIGNING_KEY) to run builder with
      #*   subnet_id        - (REQUIRED) Subnet id to deploy the instance
      #*   override_builder_AdditionalArgs - (OPTIONAL) overrides local.builder_AdditionalArgs only for the current BUIDLER instance
      #*   override_builder_release        - (OPTIONAL) overrides local.builder_release only for the current BUIDLER instance
      #*   override_nimbus_release         - (OPTIONAL) overrides local.nimbus_release only for the current BUIDLER instance
      #* },
      "builder-111_333" = {
        subnet_id = "subnet-XXXX"
        override_builder_AdditionalArgs = [
          "--http --http.api eth,net,engine,admin",
          "--cache=256", #* Only on small RAM vm
          "--builder",
          "--builder.local_relay",
          "--builder.beacon_endpoints=http://127.0.0.1:3500",
          "--metrics"
        ]
        override_builder_release = "v1.13.2-4844.dev5.c786eb74f"
        # override_nimbus_release  = "v23.10.0"
      }
      # "builder-222_333" = {
      #   subnet_id = "subnet-XXXX"
      # }
    }

  #############* Calculated locals
  builder_instances_full = { for name, conf in local.builder_instances : name => {
      subnet_id = conf.subnet_id
      builder_AdditionalArgs = try(conf.override_builder_AdditionalArgs, local.builder_AdditionalArgs)
      builder_release        = try(conf.override_builder_release, local.builder_release)
      nimbus_release         = try(conf.override_nimbus_release, local.nimbus_release)
    }
  }
}

module "builders" {
  source  = "../../modules/Builders"

  region            = local.region
  ethereum_network  = local.ethereum_network
  builder_instances = local.builder_instances_full
  ssh_key_name      = try(local.ssh_key_name, null)
  root_volume_size  = local.root_volume_size
  data_volume_size  = local.data_volume_size
  vpc_id            = local.vpc_id
  builders_instance_type          = local.builders_instance_type
  vpc_endpoints_security_group_id = local.vpc_endpoints_security_group_id
}
