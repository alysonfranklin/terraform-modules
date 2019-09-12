provider "aws" {
  region = "us-east-2"
}

resource "aws_db_instance" "example" {
  identifier   = "rds-mysql"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  name                = "example_database"
  username            = "admin"
  password = var.db_password
  skip_final_snapshot = true

}
