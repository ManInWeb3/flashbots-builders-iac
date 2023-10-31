# Ethereum HOLESKY builders
Terraform workspace deploing [Builder releases](https://github.com/ManInWeb3/flashbots-builder/releases) to [EC2 instances](https://github.com/ManInWeb3/flashbots-builders-iac/blob/main/holesky/Builders/main.tf#L38).

The module will create:
* EC2 instances configured in [builder_instances](https://github.com/ManInWeb3/flashbots-builders-iac/blob/main/holesky/Builders/main.tf#L38)
* [data_volume_size](https://github.com/ManInWeb3/flashbots-builders-iac/blob/main/holesky/Builders/main.tf#L8) Gb Data volume for each instance. Data operations are not implemented.
* Configure AWS session manager to be able to access the instance console.
* Security group to configure any required ingress and egress rules.

To deploy a new release:
1. Change the value of [builder_release](https://github.com/ManInWeb3/flashbots-builders-iac/blob/main/holesky/Builders/main.tf#L15) to the tag you want to deploy.
2. Plan and apply the terraform cloud workspace [builders-holesky-Builders](https://app.terraform.io/app/XXX/workspaces/builders-holesky-Builders).

## Pre-requisits
1. Befor deploing the instances, you need to deploy [CommonInfra](https://github.com/ManInWeb3/flashbots-builders-iac/tree/main/holesky/CommonInfra)
2. Create secret keys for each instance, will be passed as BUILDER_TX_SIGNING_KEY environment variable. **NOTE:** Name of the instances must match with the secret name to run builder with.
3. If ssh_key_name is given, you will be able to access instances via SSH. The key must be created before applying.
