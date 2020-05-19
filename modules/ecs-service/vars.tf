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
  type        = bool
  default     = false
}

variable "CREATE_ECR" {
  description = "Cria repositório ECR ou não?"
  type = bool
}

variable "DEFAULT_TAGS" {
  type = map
  default = {}
}
