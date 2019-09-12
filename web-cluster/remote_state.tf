terraform {
  backend "s3" {
    # Replace this with your bucket name!
    #bucket         = "terraform-state-homolog"
    key            = "global/s3/terraform.tfstate"
    #key            = "homolog/web-cluster/terraform.tfstate"
    #region         = "us-east-1"

    # Replace this with your DynamoDB table name!
    #dynamodb_table = "terraform-state-homolog-locks"
    #encrypt        = true
    // Definir isso como true garante que seu estado Terraform seja
    // criptografado no disco quando armazenado no S3.
  }
}

// bucket, region, dynamodb_table e encrypt estão comentados porque estou usando backend.hcl
