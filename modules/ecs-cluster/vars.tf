variable "AWS_ACCOUNT_ID" {
}

variable "AWS_REGION" {
}

variable "VPC_ID" {
}

variable "CLUSTER_NAME" {
}

variable "INSTANCE_TYPE" {
}

variable "SSH_KEY_NAME" {
}

variable "VPN_IP" {
  description = "IP da VPN que terá acesso a todas as portas das maquinas do cluster ecs"
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

variable "CP_ECS_MINSIZE" {
  type = number
  description = "Número mínimo de instâncias do Capacity Provider"
  default = 1
}

variable "CP_ECS_MAXSIZE" {
  type = number
  description = "Número máximo de instâncias do Capacity Provider"
  default = 2
}

variable "CP_ECS_DESIRED_CAPACITY" {
  type = number
  description = "Número desejado de instâncias do Capacity Provider"
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
  description = "Se definido como true, agenda o dimensionamento automático"
  type        = bool
}

variable "ENABLE_CAPACITY_PROVIDER" {
  description = "Se definido como true, cria o capacity provider para o ECS"
  type        = bool
}

variable "SCHEDULE_OUT_BUSINESS_HOURS" {
  description = "Dimensionar o número de instâncias EC2 no horário comercial"
  type        = string
}

variable "SCHEDULE_MIN_SIZE_TURNON" {
  description = "O número mínimo de instâncias EC2 no schedule do ASG - Horário comercial"
  type        = number
}

variable "SCHEDULE_MAX_SIZE_TURNON" {
  description = "O número máximo de instâncias EC2 no schedule do ASG - Horário comercial"
  type        = number
}

variable "SCHEDULE_DESIRED_CAPACITY_TURNON" {
  description = "O número desejado de instâncias EC2 no schedule do ASG - Horário comercial"
  type        = number
}

variable "SCHEDULE_MIN_SIZE_TURNOFF" {
  description = "O número mínimo de instâncias EC2 no schedule do ASG - Depois do horário comercial"
  type        = number
}

variable "SCHEDULE_MAX_SIZE_TURNOFF" {
  description = "O número máximo de instâncias EC2 no schedule do ASG - Depois do horário comercial"
  type        = number
}

variable "SCHEDULE_DESIRED_CAPACITY_TURNOFF" {
  description = "O número desejado de instâncias EC2 no schedule do ASG - Depois do horário comercial"
  type        = number
}
variable "SCHEDULE_IN_TURNOFF" {
  description = "Dimensionar o número de instâncias EC2 depois do horário comercial"
  type        = string
}

variable "additional_user_data" {
  type        = string
  description = "User data that will run at the end of the existing user data"
  default     = ""
}

variable "CONTAINER_INSIGHTS" {
  type        = bool
  description = "Habilita container_insights no cluster ECS"
  default     = false
}

variable "CAPACITY_PROVIDERS" {
  description = "Lista de nomes curtos de um ou mais provedores de capacidade para associar ao cluster. Os valores válidos também incluem FARGATE e FARGATE_ SPOT."
  type        = list(string)
  default     = []
}

variable "DEFAULT_CAPACITY_PROVIDER_STRATEGY" {
  description = "A estratégia do provedor de capacidade a ser usada por padrão para o cluster. Pode ser um ou mais."
  type        = list(map(any))
  default     = []
}

