# Terraform Workspaces for Flashbots Builder Instances

This repository contains Terraform workspaces for deploying [Flashbots Builder releases](https://github.com/ManInWeb3/flashbots-builder/releases) as AWS EC2 instances.

## Release and Deployment Architecture
![Release and Deployment Architecture Diagram](.resources/architecture_diagram.png)

1. **Builder’s GitHub Repository**: The builder's GitHub repository contains a configured [GitHub action](https://github.com/ManInWeb3/flashbots-builder/blob/deneb/.github/workflows/release.yml) that compiles the code and creates a new release with the binary.
   - **Trigger**: New **v*** tag
   - **Artifacts**: Archived binaries

2. **Terraform Cloud Workspaces**: Terraform Cloud workspaces are configured to apply Terraform code from the current repository.
   - **Trigger**: Manual or can be triggered with the GitHub action in step 1
   - **Artifacts**: VPC, Security groups, and builder instances
   - **Dependencies**: Builder's secret keys (step 4) must be created manually.

3. **Builder Instances**: These are the actual builder instances, and you can find more details in the [builders' instances repository](https://github.com/ManInWeb3/flashbots-builders-iac/tree/main/holesky/Builders/).

4. **Builder Secret Keys**: Builders' secret keys are stored in AWS Secret Manager.

5. **Common Infrastructure**: The [common infrastructure repository](https://github.com/ManInWeb3/flashbots-builders-iac/tree/main/holesky/CommonInfra) contains resources shared among the builder instances.

6. **Builder EC2 Instances**: These instances are configured using a [user_data](https://github.com/ManInWeb3/flashbots-builders-iac/blob/main/modules/Builders/files/user_data.sh.tftpl) script.
   - *Builder secret keys are read with [the instance's user_data script](https://github.com/ManInWeb3/flashbots-builders-iac/blob/main/modules/Builders/files/user_data.sh.tftpl#L71), so they are not saved in the Terraform state.*

## Repository Structure

The repository is structured as follows:

- `modules/`: This folder contains the required modules.

- `holesky/`, `mainnet/`: These folders contain Terraform workspaces to deploy builders on Ethereum HOLESKY and MAINNET.
  - [CommonInfra](https://github.com/ManInWeb3/flashbots-builders-iac/tree/main/holesky/CommonInfra): Workspaces to deploy prerequisites of the **holesky, mainnet /Builders** workspace.
    - *Common infra IaC is separated from Builders' EC2 instances IaC to:*
      - *Decrease the possibility of a mistake, e.g., renaming the VPC will force the recreation of the entire infrastructure and disrupt the service.*
      - *Make the infrastructure more flexible, allowing the same VPC to be used for all networks.*
    - These workspaces create resources required by the Builders' workspaces and should be deployed first. They manage the following resources:
      - VPC network
      - Subnetworks
      - VPC endpoints and a security group to configure [Session manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html) access.

  - [Builders](https://github.com/ManInWeb3/flashbots-builders-iac/tree/main/holesky/Builders): Workspace to deploy builder EC2 instances.
    - These workspaces create:
      - EC2 instances specified in [builder_instances](https://github.com/ManInWeb3/flashbots-builders-iac/blob/main/holesky/Builders/main.tf#L38)
      - [data_volume_size](https://github.com/ManInWeb3/flashbots-builders-iac/blob/main/holesky/Builders/main.tf#L8) Gb Data volume for each instance (data operations are not implemented).
      - Configure AWS Session Manager to access the instance console.
      - IAM role to set up Session manager and read secret keys. The IAM role allows each instance to read only the secret key with the same name.
      - Security group to configure any required ingress and egress rules.

**Prerequisites:**
1. Before deploying the instances, you need to deploy [CommonInfra](https://github.com/ManInWeb3/flashbots-builders-iac/tree/main/holesky/CommonInfra).
2. Create secret keys for each instance, which will be passed as the BUILDER_TX_SIGNING_KEY environment variable. **NOTE:** The name of the instances must match the secret name to run the builder with. This simplifies secrets management, so you always know the builder-to-secret relation.
3. If `ssh_key_name` is given, you will be able to access instances via SSH. The key must be created before applying. The main scenario to use ssh access is to rsync data, other wise Session manager access is preferable.
