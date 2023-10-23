data "aws_subnet" "this" {
  for_each = local.builder_instances
  id = each.value.subnet_id
}

resource "aws_ebs_volume" "data" {
  for_each = local.builder_instances

  availability_zone = data.aws_subnet.this[each.key].availability_zone #lookup(each.value, "availability_zone", null)
  size      = local.data_volume_size
  encrypted = true
  type      = "gp3"

  tags = merge(
    {
      "Availability_Zone" = lookup(each.value, "availability_zone", null),
      "Name" = each.key,
    },
    local.tags
  )
}

module "builder_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = ">= 5.1.0, < 6.0.0"

  name        = "builders-security-group"
  description = "Builders Security Group"

  vpc_id = local.vpc_id

  ingress_with_cidr_blocks = [
    #! OPTIONAL p2p ports
    {
      from_port     = 30303
      to_port     = 30303
      protocol    = "tcp"
      description = "Geth P2P tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port     = 30303
      to_port     = 30303
      protocol    = "udp"
      description = "Geth P2P udp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  egress_with_cidr_blocks = [
    { #* Required for SSM session manager
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS to all"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = local.tags
}

module "builder_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = ">= 5.5.0, < 6.0.0"

  for_each = local.builder_instances

  name                   = each.key
  instance_type          = local.builders_instance_type
  availability_zone      = data.aws_subnet.this[each.key].availability_zone
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = [
    module.builder_security_group.security_group_id,
    local.ssm_security_group_id,
  ]

  # External IP to expose p2p
  #* This is optional, can be without external IP, but then we need NAT gw to connect to the Internet
  associate_public_ip_address = true
  ignore_ami_changes = true              #! Don't re-create instance if newer image found
  user_data_replace_on_change = true     #! Re-create the instance if user_data changed, which is when new release deployed
  user_data_base64 = base64encode(templatefile("files/user_data.sh.tftpl", {
    ethereum_network = local.ethereum_network
    builder_release  = var.builder_release
  }))

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      volume_size = local.root_volume_size
    },
  ]

  #* SSM Session Manager
  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = merge(
    {
      "Builder_Key" = each.key,
    },
    local.tags
  )
}

resource "aws_volume_attachment" "data" {
  depends_on = [
    aws_ebs_volume.data,
    module.builder_instances,
  ]

  for_each = local.builder_instances

  volume_id   = aws_ebs_volume.data[each.key].id
  instance_id = module.builder_instances[each.key].id
  device_name = "/dev/sdh"
}
