// ECR 
resource "aws_ecr_repository" "ecs-service" {
  count = var.CREATE_ECR ? 1 : 0
  name  = var.REPO_NAME
}

