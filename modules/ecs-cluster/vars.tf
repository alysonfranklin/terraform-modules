variable "AWS_ACCOUNT_ID" {
}

variable "AWS_REGION" {
}

variable "LOG_GROUP" {
}

variable "VPC_ID" {
}

variable "CLUSTER_NAME" {
}

variable "INSTANCE_TYPE" {
}

variable "SSH_KEY_NAME" {
}

variable "VPC_SUBNETS" {
}

variable "ECS_TERMINATION_POLICIES" {
  default = "OldestLaunchConfiguration,Default"
}

variable "ECS_MINSIZE" {
  default = 1
}

variable "ECS_MAXSIZE" {
  default = 1
}

variable "ECS_DESIRED_CAPACITY" {
  default = 1
}

variable "ENABLE_SSH" {
  default = false
}

variable "SSH_SG" {
  default = ""
}

variable "DEFAULT_TAGS" {
  type    = map
  default = {}
}

variable "ENABLE_ASG_SCHEDULE" {
  description = "Se definido como true, ative o dimensionamento automático"
  type        = bool
}

variable "SCHEDULE_MIN_SIZE" {
  description = "O número mínimo de instâncias EC2 no schedule do ASG"
  type        = number
}

variable "SCHEDULE_MAX_SIZE" {
  description = "O número máximo de instâncias EC2 no schedule do ASG"
  type        = number

}
variable "SCHEDULE_DESIRED_CAPACITY" {
  description = "O número desejado de instâncias EC2 no schedule do ASG"
  type        = number
}

variable "SCHEDULE_IN_NIGHT" {
  description = "Dimensionar o número de instâncias EC2 depois do horário comercial"
  type = string
}

variable "SCHEDULE_OUT_BUSINESS_HOURS" {
  description = "Dimensionar o número de instâncias EC2 no horário comercial"
  type = string
}
