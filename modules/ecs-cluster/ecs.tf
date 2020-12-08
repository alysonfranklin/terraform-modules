// ECS ami
data "aws_ami" "ecs" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["591542846629"] // AWS
}

// ECS cluster
resource "aws_ecs_cluster" "cluster" {
  name = var.CLUSTER_NAME
  tags = var.DEFAULT_TAGS
}

data "template_file" "ecs_init" {
  template = filebase64("${path.module}/templates/ecs_init.tpl")
  #template = file("${path.module}/templates/ecs_init.tpl")
  vars = {
    CLUSTER_NAME = var.CLUSTER_NAME
  }
}

/*
// launchconfig
resource "aws_launch_configuration" "cluster" {
  name_prefix          = "ecs-${var.CLUSTER_NAME}-launchconfig"
  image_id             = data.aws_ami.ecs.id
  instance_type        = var.INSTANCE_TYPE
  key_name             = var.SSH_KEY_NAME
  iam_instance_profile = aws_iam_instance_profile.cluster-ec2-role.id
  security_groups      = [aws_security_group.cluster.id]
  user_data            = data.template_file.ecs_init.rendered
  lifecycle {
    create_before_destroy = true
  }
}
*/

resource "aws_launch_template" "ecs" {
  name                    = "ecs-${var.CLUSTER_NAME}-launchconfig"
  instance_type           = var.INSTANCE_TYPE
  image_id                = data.aws_ami.ecs.id
  disable_api_termination = true
  //security_group_names  = []
  key_name               = var.SSH_KEY_NAME
  update_default_version = true
  user_data              = data.template_file.ecs_init.rendered
  #user_data = filebase64("${path.module}/ecs_init.tpl")
  //user_data = data.template_file.ecs_init.rendered
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
  name                = "ecs-${var.CLUSTER_NAME}-autoscaling"
  vpc_zone_identifier = split(",", var.VPC_SUBNETS)
  //launch_configuration = aws_launch_configuration.cluster.name
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
    value               = "${var.CLUSTER_NAME}-ecs"
    propagate_at_launch = true
  }
}

// Schedule Autoscaling Group
resource "aws_autoscaling_schedule" "scale_out_business_hours" {
  count                  = var.ENABLE_ASG_SCHEDULE ? 1 : 0
  scheduled_action_name  = "scale-out-during-business-hours"
  min_size               = var.SCHEDULE_MIN_SIZE_COMMERCIAL
  max_size               = var.SCHEDULE_MAX_SIZE_COMMERCIAL
  desired_capacity       = var.SCHEDULE_DESIRED_CAPACITY_COMMERCIAL
  recurrence             = var.SCHEDULE_OUT_BUSINESS_HOURS
  autoscaling_group_name = aws_autoscaling_group.cluster.name
}
resource "aws_autoscaling_schedule" "scale_in_at_night" {
  count                  = var.ENABLE_ASG_SCHEDULE ? 1 : 0
  scheduled_action_name  = "scale-in-at-night"
  min_size               = var.SCHEDULE_MIN_SIZE_NIGHT
  max_size               = var.SCHEDULE_MAX_SIZE_NIGHT
  desired_capacity       = var.SCHEDULE_DESIRED_CAPACITY_NIGHT
  recurrence             = var.SCHEDULE_IN_NIGHT
  autoscaling_group_name = aws_autoscaling_group.cluster.name
}
