data "aws_subnet" "this" {
  for_each = var.builder_instances

  id = each.value.subnet_id
}

data "aws_ami" "ubuntu2204" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Create a data volume for each instance
resource "aws_ebs_volume" "data" {
  for_each = var.builder_instances

  availability_zone = data.aws_subnet.this[each.key].availability_zone
  size      = var.data_volume_size

  tags = merge(
    {
      "Availability_Zone" = lookup(each.value, "availability_zone", null),
      "Name" = each.key,
    },
    local.tags
  )
}

# Builders' security group
module "builder_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = ">= 5.1.0, < 6.0.0"

  name        = "builders-security-group"
  description = "Builders Security Group"

  vpc_id = var.vpc_id
  ingress_with_cidr_blocks = local.ingress_with_cidr_blocks

  egress_rules = local.egress_rules

  tags = local.tags
}

data "aws_secretsmanager_secret" "secret" {
  for_each = var.builder_instances
  name     = each.key
}

# Secret-manager IAM policy
resource "aws_iam_policy" "get_secret" {
  for_each = var.builder_instances

  name                   = each.key
  path        = "/"
  description = "Policy to access secrets"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue"
            ],
            "Resource": [data.aws_secretsmanager_secret.secret[each.key].arn]
        }
    ]
  })
}

module "builder_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = ">= 5.5.0, < 6.0.0"

  for_each = var.builder_instances

  name                   = each.key

  ami                    = data.aws_ami.ubuntu2204.id
  instance_type          = var.builders_instance_type
  key_name               = var.ssh_key_name
  availability_zone      = data.aws_subnet.this[each.key].availability_zone
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = [
    module.builder_security_group.security_group_id,
    var.vpc_endpoints_security_group_id,
  ]

  associate_public_ip_address = true     #* This is optional, can be without external IP, then we need NAT gw to connect to the Internet
  ignore_ami_changes = true              #* Don't re-create instance if newer image found
  user_data_replace_on_change = true     #* Re-create the instance if user_data changed, which is when new release deployed
  user_data_base64 = base64encode(templatefile("../../modules/Builders/files/user_data.sh.tftpl", {
    ethereum_network = var.ethereum_network
    builder_release  = each.value.builder_release
    builder_AdditionalArgsStr = join(" ", each.value.builder_AdditionalArgs)
    nimbus_release   = each.value.nimbus_release
    builder_name     = each.key
    data_volume_id   = aws_ebs_volume.data[each.key].id
    aws_region       = var.region
  }))

  root_block_device = [
    {
      encrypted   = true
      volume_size = var.root_volume_size
    },
  ]

  #* SSM Session Manager's roles
  create_iam_instance_profile = true
  iam_role_description        = "IAM role for Builders EC2 instance"
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    aws_iam_policy.get_secret[each.key].name = aws_iam_policy.get_secret[each.key].arn
  }

  tags = merge(
    {
      "BUILDER_TX_SIGNING_KEY_SECRET_NAME" = each.key
      "BUILDER_release" = each.value.builder_release
      "NIMBUS_release"  = each.value.nimbus_release
    },
    local.tags
  )
}

#* Attache the data volume
resource "aws_volume_attachment" "data" {
  depends_on = [
    aws_ebs_volume.data,
    module.builder_instances,
  ]

  for_each = var.builder_instances

  volume_id   = aws_ebs_volume.data[each.key].id
  instance_id = module.builder_instances[each.key].id
  device_name = "/dev/sdh"
}
