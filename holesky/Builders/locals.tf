
#* DEPENDENCIES:
#*  1. Secret key created and specified ...
#*  2. Builder release specified


locals {
  #* BUILDER release to deploy. For example: v1.13.2-4844.dev5.c786eb74f
  builder_release = "v1.13.2-4844.dev5.c786eb74f"

  #* Builder command already have the following arguments auto configured:
  #* --${local.ethereum_network}
  #* --authrpc.jwtsecret=$BUILDER_JWT_PATH
  #* --datadir=$DATA_DIR/${local.ethereum_network}/$(basename $BUILDER_BIN)
  #* --log.file=$DATA_DIR/${local.ethereum_network}/$(basename $BUILDER_BIN)_$BUILDER_RELEASE.log
  #* If you need to add arguments, add them in builder_AdditionalArgs list
  builder_AdditionalArgs = [
    "--http --http.api eth,net,engine,admin",
    "--cache=256",
    "--builder",
    "--builder.local_relay",
    "--builder.beacon_endpoints=http://127.0.0.1:3500",
  ]

  # prysm_release   = null #"v4.1.0"
  nimbus_release  = "v23.10.0"

  ethereum_network = "holesky"
  region           = "us-east-1"
  vpc_id           = "vpc-085701af4f385bba2"

  builder_instances = {
    "builder-111_333" = {
      subnet_id = "subnet-05a71022cf5148113"
    },
    # key_222_333 = {
    #   subnet_id = "dsfsdfsdfsd"
    # },
  }

  # Commont Builders settings
  # ssh_key_name = "vlad"
  builders_instance_type = "t3.medium"  #"t3.micro"
  root_volume_size       = 20
  data_volume_size       = 10

  # Security groups
  vpc_endpoints_security_group_id = "sg-00fbe09a6771db7e2"
}
