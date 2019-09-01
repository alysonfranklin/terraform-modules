provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" { 
  // Autenticando via SSH em repositório privado
  source = "git::git@github.com:alysonfranklin/terraform-modules.git//webserver-cluster?ref=stable" 

  // Baixando de repositório publico
  //source = "github.com/alysonfranklin/terraform-modules//webserver-cluster?ref=v0.0.1" 
  cluster_name = "webservers-stage" 
  instance_type = "t2.micro" 
  min_size = 2 
  max_size = 2 
  enable_autoscaling  = true
}
