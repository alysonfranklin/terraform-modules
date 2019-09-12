provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-homolog"

  # Impedir a exclusão acidental deste bucket S3
  lifecycle {
    prevent_destroy = true
  }

  # Habilitando versionamento para os arquivos de estado
  versioning {
    enabled = true
  }

  # Ativando criptografia do lado do servidor por padrão
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

// Criando tabela no DynamoDB
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-homolog-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
