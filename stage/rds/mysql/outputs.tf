output "address" {
  value       = aws_db_instance.example.address
  description = "Endpoint do Database"
}

output "port" {
  value       = aws_db_instance.example.port
  description = "Porta do Database"
}
