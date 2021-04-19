// ECR 
resource "aws_ecr_repository" "ecs-service" {
  count = var.CREATE_ECR ? 1 : 0
  name  = var.REPO_NAME
  image_scanning_configuration {
    scan_on_push = var.SCAN_ON_PUSH
  }

  tags = var.DEFAULT_TAGS
}
