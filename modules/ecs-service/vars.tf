variable "VPC_ID" {
}

variable "AWS_REGION" {
}

variable "APPLICATION_NAME" {
}

variable "APPLICATION_PORT" {
}

variable "APPLICATION_VERSION" {
}

variable "CLUSTER_ARN" {
}

variable "CLUSTER_NAME" {
}

variable "SERVICE_ROLE_ARN" {
}

variable "DESIRED_COUNT" {
}

variable "DEPLOYMENT_MINIMUM_HEALTHY_PERCENT" {
  default = 100
}

variable "DEPLOYMENT_MAXIMUM_PERCENT" {
  default = 200
}

variable "DEREGISTRATION_DELAY" {
  default = 30
}

variable "HEALTHCHECK_MATCHER" {
  default = "200"
}

variable "UNHEALTHY_THRESHOLD" {
  default = "3"
}

variable "HEALTHY_THRESHOLD" {
  default = "3"
}

variable "HEALTH_CHECK_INTERVAL" {
  default = "10"
}

variable "HEALTH_CHECK_PATH" {
  default = "/"
}

variable "LOAD_BALANCING_ALGORITHM_TYPE" {
  default = "round_robin"
}

variable "CPU_RESERVATION" {
}

variable "MEMORY_RESERVATION" {
}

variable "LOG_GROUP" {
}

variable "TASK_ROLE_ARN" {
  default = ""
}

variable "ALB_ARN" {
}

variable "ENABLE_STICKINESS" {
  type    = bool
  default = false
}

variable "DEFAULT_TAGS" {
  type    = map
  default = {}
}

variable "capacity_provider_strategies" {
  type = list(object({
    capacity_provider = string
    weight            = number
    base              = number
  }))
  description = "The capacity provider strategies to use for the service. See `capacity_provider_strategy` configuration block: https://www.terraform.io/docs/providers/aws/r/ecs_service.html#capacity_provider_strategy"
  default     = []
}

variable "launch_type" {
  type        = string
  description = "The launch type on which to run your service. Valid values are `EC2` and `FARGATE`"
  default     = "EC2"
}
