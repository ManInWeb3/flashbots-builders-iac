locals{
  # To be able to re-use it in provider
  region = "us-east-1"
}
module "builders" {
  source  = "../../modules/Builders"

  #* To deploy a new builder release, change this value.
  #* For example: v1.13.2-4844.dev5.c786eb74f
  builder_release = "v1.13.2-4844.dev5.newrelease"

  #* Builder command already have the following arguments auto configured:
  #* --${ethereum_network}
  #* --authrpc.jwtsecret=$BUILDER_JWT_PATH
  #* --datadir=$DATA_DIR/${ethereum_network}/$(basename $BUILDER_BIN)
  #* --log.file=$DATA_DIR/${ethereum_network}/$(basename $BUILDER_BIN)_$BUILDER_RELEASE.log
  #* If you need to add more arguments, add them in builder_AdditionalArgs list
  builder_AdditionalArgs = [
    "--http --http.api eth,net,engine,admin",
    "--cache=256", # Only on small RAM vm
    "--builder",
    "--builder.local_relay",
    "--builder.beacon_endpoints=http://127.0.0.1:3500",
    "--metrics"
  ]

  # prysm_release   = null #"v4.1.0"
  #* Beacon node release tag
  nimbus_release  = "v23.10.0"

  #* Ethereum network to deploy
  ethereum_network = "holesky"

  #* List of builders to deploy
  builder_instances = {
    #* Example builder
    #* "builder_name" = {
    #*   subnet_id = "Subnet id to deploy the instance"
    #* },
    #* builder_name - Name of the instance and secret name, which stores the secret key ($BUILDER_TX_SIGNING_KEY) to run builder with
    "builder-111_333" = {
      subnet_id = "subnet-05a71022cf5148113"
      override_builder_AdditionalArgs = [
        "--http --http.api eth,net,engine,admin",
        "--cache=256", # Only on small RAM vm
        "--builder",
        "--builder.local_relay",
        "--builder.beacon_endpoints=http://127.0.0.1:3500",
        "--metrics"
      ]
      override_builder_release = "v1.13.2-4844.dev5.newrelease"
      override_nimbus_release  = "v23.10.0"
    },
    # "builder-222_333" = {
    #   subnet_id = "subnet-05a71022cf5148113"
    #   override_builder_AdditionalArgs = [
    #     "--http --http.api eth,net,engine,admin",
    #     "--cache=256", # Only on small RAM vm
    #     "--builder",
    #     "--builder.local_relay",
    #     "--builder.beacon_endpoints=http://127.0.0.1:3500",
    #     "--metrics"
    #   ]
    #   override_builder_release = "v1.13.2-4844.dev5.newrelease"
    #   override_nimbus_release  = "v23.10.0"
    # },
  }

  #* Builders common settings
  ssh_key_name           = "vlad"                  # Only to rsync data, to access instance's console use Session manager
  builders_instance_type = "t3.medium"             #"t3.micro"
  root_volume_size       = 20
  data_volume_size       = 10
  region                 = local.region            # See value in locals above
  vpc_id                 = "vpc-085701af4f385bba2"
  vpc_endpoints_security_group_id = "sg-00fbe09a6771db7e2"   # VPC Endpoint security group, created in common infra module
}
