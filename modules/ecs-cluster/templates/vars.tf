variable "DEFAULT_TAGS" {
  type = map
  default = {
    Environment = "prod"
    Project     = "solfacil"
    Terraform   = "true"
  }
}
