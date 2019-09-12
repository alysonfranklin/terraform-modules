provider "aws" {
  region  = "us-east-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = terraform.workspace == "default" ? "t2.micro" : "t2.small"
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "terraform-state-homolog"
    key            = "workspaces/terraform.tfstate"
    region         = "us-east-1"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-state-homolog-locks"
    encrypt        = true
  }
}
