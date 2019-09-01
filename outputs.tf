output "DNS_Name" { 
  value = module.webserver_cluster.aws_elb.example.dns_name
  description = "DNS do LoadBalancer" 
}
