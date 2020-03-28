/*output "public_ip" { 
  value = aws_instance.example.public_ip 
  description = "O IP público do servidor web" 
}
*/

output "DNS_Name" {
  value       = aws_elb.example.dns_name
  description = "DNS do LoadBalancer"
}
