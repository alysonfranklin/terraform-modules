variable "DEFAULT_TAGS" {
  description = "Variáveis padrão"
  type = map(string)
  default = {}
}

variable "LOG_GROUP" {
  description = "Nome/Caminho do log_group"
  default = "" // Se o nome do log_group não for informado, será criado um log_group com nome aleatório
}

variable "CREATE_LOG_GROUP" {
  type = bool
  default = true
}
