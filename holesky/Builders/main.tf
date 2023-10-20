module "ec2_multiple" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = ">= 5.5.0, < 6.0.0"

  for_each = local.multiple_instances

  name = "${local.name}-multi-${each.key}"

  instance_type          = each.value.instance_type
  availability_zone      = each.value.availability_zone
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = [module.security_group.security_group_id]

  enable_volume_tags = false
  root_block_device  = lookup(each.value, "root_block_device", [])

  tags = local.tags
}

resource "aws_volume_attachment" "this" {
  for_each = local.multiple_instances

  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.this.id
  instance_id = module.ec2.id
}

resource "aws_ebs_volume" "this" {
  for_each = local.multiple_instances

  availability_zone = module.ec2.availability_zone
  size              = lookup(each.value, "data_volume_size")

  tags = local.tags
}
