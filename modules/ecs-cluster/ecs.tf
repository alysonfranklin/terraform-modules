// ECS ami
data "aws_ami" "ecs" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

// ECS cluster
resource "aws_ecs_cluster" "cluster" {
  name               = var.CLUSTER_NAME
  tags               = var.DEFAULT_TAGS
  capacity_providers = var.ENABLE_CAPACITY_PROVIDER == true ? aws_ecs_capacity_provider.ecs[*].name : []

  dynamic "default_capacity_provider_strategy" {
    for_each = var.DEFAULT_CAPACITY_PROVIDER_STRATEGY
    iterator = strategy

    content {
      capacity_provider = strategy.value["capacity_provider"]
      weight            = lookup(strategy.value, "weight", null)
      base              = lookup(strategy.value, "base", null)
    }
  }

  setting {
    name  = "containerInsights"
    value = var.CONTAINER_INSIGHTS ? "enabled" : "disabled"
  }
}

# Render a part using a `template_file`
data "template_file" "ecs_init" {
  template = file("${path.module}/templates/ecs_init.tpl")
  #template = "${file("${path.module}/templates/ecs_init.tpl")}"

  vars = {
    CLUSTER_NAME = var.CLUSTER_NAME
  }
}

# Render a multi-part cloudinit config making use of the part
# above, and other source files
data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = true

  part {
    #order        = 1
    #filename     = "init.sh"
    content_type = "text/x-shellscript"

    content = data.template_file.ecs_init.rendered
  }

  part {
    # order        = 2
    content_type = "text/x-shellscript"
    content      = var.additional_user_data
  }
}

resource "aws_launch_template" "ecs" {
  name                    = "ecs-${var.CLUSTER_NAME}-${var.DEFAULT_TAGS["Environment"]}"
  instance_type           = var.INSTANCE_TYPE
  image_id                = data.aws_ami.ecs.id
  disable_api_termination = true
  //security_group_names  = []
  key_name               = var.SSH_KEY_NAME
  update_default_version = true
  user_data              = data.template_cloudinit_config.config.rendered
  tags                   = var.DEFAULT_TAGS
  vpc_security_group_ids = [aws_security_group.cluster.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.cluster-ec2-role.id
  }

  metadata_options {

    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
  }

  monitoring {
    enabled = false
  }

  tag_specifications {
    resource_type = "instance"
    tags          = var.DEFAULT_TAGS
  }

  /*
  tag_specifications {
    resource_type = "elastic-gpu"
    tags          = var.DEFAULT_TAGS
  }

  tag_specifications {
    resource_type = "spot-instances-request"
    tags          = var.DEFAULT_TAGS
  }
  */

  lifecycle {
    create_before_destroy = true
  }
}

// Autoscaling
resource "aws_autoscaling_group" "cluster" {
  name                 = "ecs-${var.CLUSTER_NAME}-${var.DEFAULT_TAGS["Environment"]}"
  vpc_zone_identifier  = split(",", var.VPC_SUBNETS)
  termination_policies = split(",", var.ECS_TERMINATION_POLICIES)
  min_size             = var.ECS_MINSIZE
  max_size             = var.ECS_MAXSIZE
  desired_capacity     = var.ECS_DESIRED_CAPACITY

  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.CLUSTER_NAME}-ecs-${var.DEFAULT_TAGS["Environment"]}"
    propagate_at_launch = true
  }
}

// Schedule Autoscaling Group
resource "aws_autoscaling_schedule" "TURNON" {
  count                  = var.ENABLE_ASG_SCHEDULE ? 1 : 0
  scheduled_action_name  = "TurnOn"
  min_size               = var.SCHEDULE_MIN_SIZE_TURNON
  max_size               = var.SCHEDULE_MAX_SIZE_TURNON
  desired_capacity       = var.SCHEDULE_DESIRED_CAPACITY_TURNON
  recurrence             = var.SCHEDULE_OUT_BUSINESS_HOURS
  autoscaling_group_name = aws_autoscaling_group.cluster.name
}
resource "aws_autoscaling_schedule" "TURNOFF" {
  count                  = var.ENABLE_ASG_SCHEDULE ? 1 : 0
  scheduled_action_name  = "TurnOff"
  min_size               = var.SCHEDULE_MIN_SIZE_TURNOFF
  max_size               = var.SCHEDULE_MAX_SIZE_TURNOFF
  desired_capacity       = var.SCHEDULE_DESIRED_CAPACITY_TURNOFF
  recurrence             = var.SCHEDULE_IN_TURNOFF
  autoscaling_group_name = aws_autoscaling_group.cluster.name
}

// Capacity Provider
resource "aws_ecs_capacity_provider" "ecs" {
  count      = var.ENABLE_CAPACITY_PROVIDER ? 1 : 0
  name       = "capacity_provider-ecs-${var.CLUSTER_NAME}-${var.DEFAULT_TAGS["Environment"]}"
  depends_on = [aws_autoscaling_group.ecs]

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs[0].arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 0
      status          = "ENABLED"
      target_capacity = 100
    }
  }
}

resource "aws_autoscaling_group" "ecs" {
  count                = var.ENABLE_CAPACITY_PROVIDER ? 1 : 0
  name                 = "capacity_provider-ecs-${var.CLUSTER_NAME}-${var.DEFAULT_TAGS["Environment"]}"
  vpc_zone_identifier  = split(",", var.VPC_SUBNETS)
  termination_policies = split(",", var.ECS_TERMINATION_POLICIES)
  min_size             = var.CP_ECS_MINSIZE
  max_size             = var.CP_ECS_MAXSIZE
  desired_capacity     = var.CP_ECS_DESIRED_CAPACITY

  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.CLUSTER_NAME}-ecs-${var.DEFAULT_TAGS["Environment"]}"
    propagate_at_launch = true
  }
}
