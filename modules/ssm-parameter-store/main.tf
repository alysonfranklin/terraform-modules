provider "aws" {
  region = "us-east-1"
}

module "store_write" {
  source = "git::https://github.com/cloudposse/terraform-aws-ssm-parameter-store?ref=master"
  parameter_write = [{
    name        = "/staging/databases/dne"
    value       = "password!@#"
    type        = "SecureString"
    overwrite   = "true"
    description = "Production database master password"
  }]

  tags = {
    Terraform   = "true"
    Environment = "Staging"
    Project     = "DNE"
  }
}
