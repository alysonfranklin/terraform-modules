output "arn" {
  value = aws_ecr_repository.ecs-service[0].arn
}
