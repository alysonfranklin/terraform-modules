resource "aws_sqs_queue" "terraform_queue" {
  name                              = var.QUEUE_NAME
  fifo_queue                        = var.CREATE_FIFO_QUEUE
  content_based_deduplication       = var.CONTENT_DEDUPLICATION
  kms_master_key_id                 = "alias/aws/sqs"
  kms_data_key_reuse_period_seconds = 300
  tags                              = var.DEFAULT_TAGS
}
