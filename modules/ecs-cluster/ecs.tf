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
  name = "${var.CLUSTER_NAME}-${var.DEFAULT_TAGS["Environment"]}"
  tags = var.DEFAULT_TAGS
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
  name                = "ecs-${var.CLUSTER_NAME}-${var.DEFAULT_TAGS["Environment"]}"
  vpc_zone_identifier = split(",", var.VPC_SUBNETS)
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
