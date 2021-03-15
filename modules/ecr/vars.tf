variable "REPO_NAME" {
  description = "Nome do repositório de imagens Docker"
  type        = string
}

variable "CREATE_ECR" {
  description = "Cria repositório ECR ou não?"
  type        = bool
  default     = true
}
