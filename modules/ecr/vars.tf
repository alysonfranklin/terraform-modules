variable "REPO_NAME" {
  description = "Nome do repositório de imagens Docker"
  type        = string
}

variable "CREATE_ECR" {
  description = "Cria repositório ECR ou não?"
  type        = bool
  default     = true
}

variable "SCAN_ON_PUSH" {
  description = "Indica se as imagens são escaneadas após serem enviadas para o repositório ECR"
  type        = bool
  default     = true
}

variable "DEFAULT_TAGS" {
  type    = map
  default = {}
}
