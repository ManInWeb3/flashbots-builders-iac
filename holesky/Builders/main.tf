data "aws_ami" "amazon_linux_latest" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_subnet" "this" {
  for_each = local.builder_instances

  id = each.value.subnet_id
}

resource "aws_ebs_volume" "data" {
  for_each = local.builder_instances

  availability_zone = data.aws_subnet.this[each.key].availability_zone #lookup(each.value, "availability_zone", null)
  size              = local.data_volume_size

  tags = merge(
    {
      "Availability_Zone" = lookup(each.value, "availability_zone", null),
      "Name" = each.key,
    },
    local.tags
  )
}


module "builder_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = ">= 5.5.0, < 6.0.0"

  for_each = local.builder_instances

  name = each.key
  instance_type          = local.builder_instances_type
  availability_zone      = data.aws_subnet.this[each.key].availability_zone
  subnet_id              = each.value.subnet_id
  # vpc_security_group_ids = [module.security_group.security_group_id]                 

  ami                = data.aws_ami.amazon_linux_latest.id
  ignore_ami_changes = true              #! Don't re-create instance if newer image found

  user_data_replace_on_change = true     #! Re-create the instance on each new release
  user_data_base64 = base64encode(<<-EOT
    #!/bin/bash
    echo "Hello Terraform!"
  EOT
  )

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      volume_size = local.root_volume_size
    },
  ]
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
