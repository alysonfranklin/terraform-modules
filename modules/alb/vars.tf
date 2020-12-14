variable "ALB_NAME" {
}

variable "INTERNAL" {
}

variable "VPC_ID" {
}

variable "VPC_SUBNETS" {
}

variable "DOMAIN" {
}

variable "DEFAULT_TARGET_ARN" {
}

variable "ECS_SG" {
  default = ""
}

variable "DEFAULT_TAGS" {
  type    = map
  default = {}
}

variable "ENABLE_DELETION_PROTECTION" {
  description = "Ativa proteção contra exclusão do ALB"
  type = bool
  default = true
}
