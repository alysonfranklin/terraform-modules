# backend.hcl
bucket         = "terraform-state-homolog"
region         = "us-east-1"
dynamodb_table = "terraform-state-homolog-locks"
encrypt        = true

# terraform12 init -backend-config=backend.hcl
