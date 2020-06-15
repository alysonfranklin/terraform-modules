variable "CREATE_FIFO_QUEUE" {
  description = "O tipo da fila é fifo?"
  type        = bool
  default     = false
}

variable "DEFAULT_TAGS" {
  description = "Variáveis padrão"
  type        = map(string)
  default     = {}
}

variable "QUEUE_NAME" {
  description = "Nome da file"
}

variable "CONTENT_DEDUPLICATION" {
  description = "Opcional - Ativa a deduplicação baseada em conteúdo para filas FIFO."
  type        = bool
  default     = false
}
