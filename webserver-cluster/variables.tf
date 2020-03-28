variable "server_port" {
  description = "A porta que o servidor usará para solicitações HTTP"
  default     = 8080
}

variable "cluster_name" {
  description = "O nome a ser usado para todos os recursos do cluster"
  type        = string
}

variable "instance_type" {
  description = "O tipo de instâncias do EC2 para executar (por exemplo, t2.micro)"
  type        = string
}

variable "min_size" {
  description = "Número mínimo de instâncias do EC2 no ASG"
  type        = number
}

variable "max_size" {
  description = "O número máximo de Instâncias do EC2 no ASG"
  type        = number
}

/*
output "asg_name" { 
  value = aws_autoscaling_group.example.name 
  description = "O nome do grupo de escalonamento automático" 
}
*/
