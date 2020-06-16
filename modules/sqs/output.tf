output "sqs_endpoint" {
  value = aws_sqs_queue.terraform_queue.id
}
