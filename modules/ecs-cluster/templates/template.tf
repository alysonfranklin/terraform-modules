provider "aws" {
  region = "us-east-1"
}

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

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["591542846629"] // AWS
}

resource "aws_launch_template" "ecs" {
  name = "ecs"
  instance_type = "t3a.micro"
  image_id  = data.aws_ami.ecs.id
  disable_api_termination = true
  //security_group_names  = []
  key_name  = "jenkins"
  update_default_version = true
  user_data = filebase64("${path.module}/ecs_init.tpl")
  tags = var.DEFAULT_TAGS
  vpc_security_group_ids  = ["sg-058b5e336b0e4f9e6"]
  iam_instance_profile {
    name = "JenkinsEC2"
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

  tag_specifications {
    resource_type = "elastic-gpu"
    tags          = var.DEFAULT_TAGS
  }

  tag_specifications {
    resource_type = "spot-instances-request"
    tags          = var.DEFAULT_TAGS
  }
  
  lifecycle {
    create_before_destroy = true
  }
}
