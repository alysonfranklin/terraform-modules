// Cria uma tabela no DynamoDB para usar no bloqueio de estado do terraform
resource "aws_dynamodb_table" "lock_state" {
  name = var.dynamo_db_table_name

// O pagamento por solicitação é mais barato para aplicativos de baixa E/S, como nosso estado de bloqueio .tf
  billing_mode = "PAY_PER_REQUEST"

// A chave de hash é necessária e deve ser um atributo
  hash_key = "LockID"

// O atributo LockID é necessário para que o TF use esta tabela para o estado de bloqueio
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name      = var.dynamo_db_table_name
    Terraform = "true"
  }
}
