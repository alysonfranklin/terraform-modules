// AMI Amazon Linux
data "aws_ami" "amazon_linux" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "name"

    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }

}

// AMI Ubuntu
data "aws_ami" "ubuntu" {
  owners = ["099720109477"] # Canonical
  most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

/*
resource "aws_instance" "example" { 
  ami = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type 
  vpc_security_group_ids  = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
    tags = { 
    Name = "${var.cluster_name}-instance" 
  }
}
*/

resource "aws_security_group" "instance" {
  name = "${var.cluster_name}-instance"
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    security_groups = [aws_security_group.elb.id]
    description = "${var.cluster_name}-sg-elb"
  }
}


// LaunchConfiguration - Template do ASG
resource "aws_launch_configuration" "example" {
  image_id        = data.aws_ami.amazon_linux.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.instance.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Ola, Mimosa =D" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
              
  lifecycle {
    create_before_destroy = true # Cria um recurso novo primeiro e depois exclua o antigo
  }
}


// Procurar as zonas de disponibilidade
data "aws_availability_zones" "azs" {}

// AutoScalingGroup
resource "aws_autoscaling_group" "example" { 
  launch_configuration = aws_launch_configuration.example.id 
  min_size = var.min_size
  max_size = var.max_size 
  availability_zones  = data.aws_availability_zones.azs.names
	load_balancers	= [aws_elb.example.name]
	health_check_type	= "ELB"

  tag { 
    key = "Name" 
    value = "${var.cluster_name}-asg" 
    propagate_at_launch = true 
  } 
}

/*
// Agendamento automatico do AutoScalingGroup - Add + instancias as 9h
resource "aws_autoscaling_schedule" "scale_out_business_hours" {
  scheduled_action_name = "scale-out-during-business-hours"
  min_size              = var.min_size
  max_size              = var.max_size
  desired_capacity      = var.min_size
  recurrence            = "0 9 * * *"
}

// Agendamento automatico do AutoScalingGroup - Remove instancias as 17h
resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name = "scale-in-at-night"
  min_size              = var.min_size
  max_size              = var.max_size
  desired_capacity      = var.min_size
  recurrence            = "0 17 * * *"
}
*/

// LoadBalancer
resource "aws_elb" "example" { 
  name = "${var.cluster_name}-elb" 
  availability_zones = data.aws_availability_zones.azs.names 
  security_groups  = [aws_security_group.elb.id]

  health_check {
	target              = "HTTP:${var.server_port}/"
	  interval            = 10
	  timeout             = 3
	  healthy_threshold   = 2
	  unhealthy_threshold = 2
	 }

    # Isso adiciona um ouvinte para solicitações HTTP de entrada. 
  listener { 
    lb_port = 80 
    lb_protocol = "http" 
    instance_port = var.server_port 
    instance_protocol = "http" 
  }

}

// SecurityGroup LoadBalancer
resource "aws_security_group" "elb" {
  name = "${var.cluster_name}-elb"
  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Inbound HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
