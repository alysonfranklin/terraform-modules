resource "aws_cloudwatch_log_group" "this" {
  count = var.CREATE_LOG_GROUP == true ? 1 : 0

  name = var.LOG_GROUP != "" ? var.LOG_GROUP : random_string.random.result
  tags = var.DEFAULT_TAGS
}

resource "random_string" "random" {
  length  = 16
  upper   = false
  special = false
}
