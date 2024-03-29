// Obtenha a revisão ativa mais recente
data "aws_ecs_task_definition" "ecs-service" {
  task_definition = aws_ecs_task_definition.ecs-service-taskdef.family
  depends_on      = [aws_ecs_task_definition.ecs-service-taskdef]
}

// Task definition template

data "template_file" "ecs-service" {
  template = file("${path.module}/ecs-service.json")

  vars = {
    APPLICATION_NAME    = var.APPLICATION_NAME
    APPLICATION_PORT    = var.APPLICATION_PORT
    APPLICATION_VERSION = var.APPLICATION_VERSION
    #ECR_URL             = aws_ecr_repository.ecs-service.repository_url
    AWS_REGION         = var.AWS_REGION
    CPU_RESERVATION    = var.CPU_RESERVATION
    MEMORY_RESERVATION = var.MEMORY_RESERVATION
    LOG_GROUP          = var.LOG_GROUP
  }
}

// Task definition

resource "aws_ecs_task_definition" "ecs-service-taskdef" {
  family                = var.APPLICATION_NAME
  container_definitions = data.template_file.ecs-service.rendered
  task_role_arn         = var.TASK_ROLE_ARN
}

// ECS Service

resource "aws_ecs_service" "ecs-service" {
  name        = var.APPLICATION_NAME
  cluster     = var.CLUSTER_ARN
  launch_type = length(var.capacity_provider_strategies) > 0 ? null : var.launch_type
  task_definition = "${aws_ecs_task_definition.ecs-service-taskdef.family}:${max(
    aws_ecs_task_definition.ecs-service-taskdef.revision,
    data.aws_ecs_task_definition.ecs-service.revision,
  )}"
  iam_role                           = var.SERVICE_ROLE_ARN
  desired_count                      = var.DESIRED_COUNT
  deployment_minimum_healthy_percent = var.DEPLOYMENT_MINIMUM_HEALTHY_PERCENT
  deployment_maximum_percent         = var.DEPLOYMENT_MAXIMUM_PERCENT

  dynamic "capacity_provider_strategy" {
    for_each = var.capacity_provider_strategies
    content {
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight            = capacity_provider_strategy.value.weight
      base              = lookup(capacity_provider_strategy.value, "base", null)
    }
  }

  ordered_placement_strategy {
    field = "attribute:ecs.availability-zone"
    type  = "spread"
  }

  ordered_placement_strategy {
    field = "instanceId"
    type  = "spread"
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.ecs-service.id
    container_name   = var.APPLICATION_NAME
    container_port   = var.APPLICATION_PORT
  }

  depends_on = [null_resource.alb_exists]
  tags       = var.DEFAULT_TAGS
}

resource "null_resource" "alb_exists" {
  triggers = {
    alb_name = var.ALB_ARN
  }
}

