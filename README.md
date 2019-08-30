# terraform-modules
Modulos do Terraform

Create main.tf

provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  source = "github.com/alysonfranklin/terraform-modules//webserver-cluster?ref=v0.0.1"
  cluster_name = "webservers-stage"
  instance_type = "t2.micro"
  min_size = 2
  max_size = 2
}

Running
$ terraform init && terraform plan && terraform apply
