output "vpc_id" {
  description = "O ID da VPC"
  value       = concat(aws_vpc.this.*.id, [""])[0]
}

output "vpc_arn" {
  description = "O ARN da VPC"
  value       = concat(aws_vpc.this.*.arn, [""])[0]
}

output "vpc_cidr_block" {
  description = "O bloco CIDR da VPC"
  value       = concat(aws_vpc.this.*.cidr_block, [""])[0]
}

output "default_security_group_id" {
  description = "O ID do grupo de segurança criado por padrão na criação da VPC"
  value       = concat(aws_vpc.this.*.default_security_group_id, [""])[0]
}

output "default_network_acl_id" {
  description = "O ID da ACL de rede padrão"
  value       = concat(aws_vpc.this.*.default_network_acl_id, [""])[0]
}

output "default_route_table_id" {
  description = "O ID da tabela de rota padrão"
  value       = concat(aws_vpc.this.*.default_route_table_id, [""])[0]
}

output "vpc_instance_tenancy" {
  description = "Tenancy das instancias da VPC"
  value       = concat(aws_vpc.this.*.instance_tenancy, [""])[0]
}

output "vpc_enable_dns_support" {
  description = "Se a VPC tem ou não suporte DNS"
  value       = concat(aws_vpc.this.*.enable_dns_support, [""])[0]
}

output "vpc_enable_dns_hostnames" {
  description = "Se a VPC tem ou não suporte para nome de host DNS"
  value       = concat(aws_vpc.this.*.enable_dns_hostnames, [""])[0]
}

//output "vpc_enable_classiclink" {
//  description = "Se o VPC tem ou não o Classiclink ativado"
//  value       = "${element(concat(aws_vpc.this.*.enable_classiclink, list("")), 0)}"
//}

output "vpc_main_route_table_id" {
  description = "O ID da tabela de rotas principal associada a esta VPC"
  value       = concat(aws_vpc.this.*.main_route_table_id, [""])[0]
}

//output "vpc_ipv6_association_id" {
//  description = "O ID da associação para o bloco IPv6 CIDR"
//  value       = "${element(concat(aws_vpc.this.*.ipv6_association_id, list("")), 0)}"
//}
//
//output "vpc_ipv6_cidr_block" {
//  description = "O bloco CIDR do IPv6"
//  value       = "${element(concat(aws_vpc.this.*.ipv6_cidr_block, list("")), 0)}"
//}

output "vpc_secondary_cidr_blocks" {
  description = "Lista de blocos CIDR secundários da VPC"
  value       = aws_vpc_ipv4_cidr_block_association.this.*.cidr_block
}

output "private_subnets" {
  description = "Lista de IDs de sub-redes privadas"
  value       = aws_subnet.private.*.id
}

output "private_subnet_arns" {
  description = "Lista de ARNs de sub-redes privadas"
  value       = aws_subnet.private.*.arn
}

output "private_subnets_cidr_blocks" {
  description = "Lista de cidr_blocks de sub-redes privadas"
  value       = aws_subnet.private.*.cidr_block
}

output "public_subnets" {
  description = "Lista de IDs de sub-redes públicas"
  value       = aws_subnet.public.*.id
}

output "public_subnet_arns" {
  description = "Lista de ARNs de sub-redes públicas"
  value       = aws_subnet.public.*.arn
}

output "public_subnets_cidr_blocks" {
  description = "Lista de cidr_blocks de sub-redes públicas"
  value       = aws_subnet.public.*.cidr_block
}

output "database_subnets" {
  description = "Lista de IDs de sub-redes de banco de dados"
  value       = aws_subnet.database.*.id
}

output "database_subnet_arns" {
  description = "Lista de ARNs de sub-redes de banco de dados"
  value       = aws_subnet.database.*.arn
}

output "database_subnets_cidr_blocks" {
  description = "Lista de cidr_blocks de sub-redes de banco de dados"
  value       = aws_subnet.database.*.cidr_block
}

output "database_subnet_group" {
  description = "ID do grupo de sub-rede do banco de dados"
  value       = concat(aws_db_subnet_group.database.*.id, [""])[0]
}

output "redshift_subnets" {
  description = "Lista de IDs de sub-redes para o redshift"
  value       = aws_subnet.redshift.*.id
}

output "redshift_subnet_arns" {
  description = "Lista de ARNs de sub-redes para o redshift"
  value       = aws_subnet.redshift.*.arn
}

output "redshift_subnets_cidr_blocks" {
  description = "Lista de cidr_blocks de sub-redes redshift"
  value       = aws_subnet.redshift.*.cidr_block
}

output "redshift_subnet_group" {
  description = "ID do grupo de sub-rede redshift"
  value       = concat(aws_redshift_subnet_group.redshift.*.id, [""])[0]
}

output "elasticache_subnets" {
  description = "Lista de ARNs de sub-redes elasticache"
  value       = aws_subnet.elasticache.*.id
}

output "elasticache_subnet_arns" {
  description = "Lista de ARNs de sub-redes elasticache"
  value       = aws_subnet.elasticache.*.arn
}

output "elasticache_subnets_cidr_blocks" {
  description = "Lista de cidr_blocks de sub-redes elasticache"
  value       = aws_subnet.elasticache.*.cidr_block
}

output "intra_subnets" {
  description = "Lista de IDs de sub-redes intra"
  value       = aws_subnet.intra.*.id
}

output "intra_subnet_arns" {
  description = "Lista de ARNs de sub-redes"
  value       = aws_subnet.intra.*.arn
}

output "intra_subnets_cidr_blocks" {
  description = "Lista de cidr_blocks de intra-redes"
  value       = aws_subnet.intra.*.cidr_block
}

output "elasticache_subnet_group" {
  description = "ID do grupo de sub-rede elasticache"
  value       = concat(aws_elasticache_subnet_group.elasticache.*.id, [""])[0]
}

output "elasticache_subnet_group_name" {
  description = "Nome do grupo de sub-rede elasticache"
  value       = concat(aws_elasticache_subnet_group.elasticache.*.name, [""])[0]
}

output "public_route_table_ids" {
  description = "Lista de IDs de tabelas de rotas públicas"
  value       = aws_route_table.public.*.id
}

output "private_route_table_ids" {
  description = "Lista de IDs de tabelas de rotas privadas"
  value       = aws_route_table.private.*.id
}

output "database_route_table_ids" {
  description = "Lista de IDs de tabelas de rotas do banco de dados"
  value       = length(aws_route_table.database.*.id) > 0 ? aws_route_table.database.*.id : aws_route_table.private.*.id
}

output "redshift_route_table_ids" {
  description = "Lista de IDs de tabelas de rotas para o redshift"
  value       = length(aws_route_table.redshift.*.id) > 0 ? aws_route_table.redshift.*.id : aws_route_table.private.*.id
}

output "elasticache_route_table_ids" {
  description = "Lista de IDs de tabelas de rotas elasticache"
  value       = length(aws_route_table.elasticache.*.id) > 0 ? aws_route_table.elasticache.*.id : aws_route_table.private.*.id
}

output "intra_route_table_ids" {
  description = "Lista de IDs de rotas de tabelas intra"
  value       = aws_route_table.intra.*.id
}

output "nat_ids" {
  description = "Lista de identificação de alocação de IPs criados para o AWS NAT Gateway"
  value       = aws_eip.nat.*.id
}

output "nat_public_ips" {
  description = "Lista de IPs elásticos públicos criados para o AWS NAT Gateway"
  value       = aws_eip.nat.*.public_ip
}

output "natgw_ids" {
  description = "Lista de IDs de NAT Gateway"
  value       = aws_nat_gateway.this.*.id
}

output "igw_id" {
  description = "O ID do Internet Gateway"
  value       = concat(aws_internet_gateway.this.*.id, [""])[0]
}

output "vgw_id" {
  description = "O ID do VPN Gateway"
  value = concat(
    aws_vpn_gateway.this.*.id,
    aws_vpn_gateway_attachment.this.*.vpn_gateway_id,
    [""],
  )[0]
}

output "default_vpc_id" {
  description = "O ID da VPC"
  value       = concat(aws_default_vpc.this.*.id, [""])[0]
}

output "default_vpc_cidr_block" {
  description = "O bloco CIDR da VPC"
  value       = concat(aws_default_vpc.this.*.cidr_block, [""])[0]
}

output "default_vpc_default_security_group_id" {
  description = "O ID do grupo de segurança criado por padrão na criação da VPC"
  value       = concat(aws_default_vpc.this.*.default_security_group_id, [""])[0]
}

output "default_vpc_default_network_acl_id" {
  description = "O ID da ACL de rede padrão"
  value       = concat(aws_default_vpc.this.*.default_network_acl_id, [""])[0]
}

output "default_vpc_default_route_table_id" {
  description = "O ID da tabela de rota padrão"
  value       = concat(aws_default_vpc.this.*.default_route_table_id, [""])[0]
}

output "default_vpc_instance_tenancy" {
  description = "Tenancy de instancias da VPC"
  value       = concat(aws_default_vpc.this.*.instance_tenancy, [""])[0]
}

output "default_vpc_enable_dns_support" {
  description = "Se a VPC tem ou não suporte DNS"
  value       = concat(aws_default_vpc.this.*.enable_dns_support, [""])[0]
}

output "default_vpc_enable_dns_hostnames" {
  description = "Se a VPC tem ou não suporte para nome de host DNS"
  value       = concat(aws_default_vpc.this.*.enable_dns_hostnames, [""])[0]
}

//output "default_vpc_enable_classiclink" {
//  description = "Se o VPC tem ou não o Classiclink ativado"
//  value       = "${element(concat(aws_default_vpc.this.*.enable_classiclink, list("")), 0)}"
//}

output "default_vpc_main_route_table_id" {
  description = "O ID da tabela de rotas principal associada a esta VPC"
  value       = concat(aws_default_vpc.this.*.main_route_table_id, [""])[0]
}

//output "default_vpc_ipv6_association_id" {
//  description = "O ID da associação para o bloco IPv6 CIDR"
//  value       = "${element(concat(aws_default_vpc.this.*.ipv6_association_id, list("")), 0)}"
//}
//
//output "default_vpc_ipv6_cidr_block" {
//  description = "O bloco CIDR do IPv6"
//  value       = "${element(concat(aws_default_vpc.this.*.ipv6_cidr_block, list("")), 0)}"
//}

output "public_network_acl_id" {
  description = "ID da rede pública ACL"
  value       = concat(aws_network_acl.public.*.id, [""])[0]
}

output "private_network_acl_id" {
  description = "ID da rede privada ACL"
  value       = concat(aws_network_acl.private.*.id, [""])[0]
}

output "intra_network_acl_id" {
  description = "ID da ACL intra"
  value       = concat(aws_network_acl.intra.*.id, [""])[0]
}

output "database_network_acl_id" {
  description = "ID da ACL da rede de banco de dados"
  value       = concat(aws_network_acl.database.*.id, [""])[0]
}

output "redshift_network_acl_id" {
  description = "ID da ACL da rede do redshift"
  value       = concat(aws_network_acl.redshift.*.id, [""])[0]
}

output "elasticache_network_acl_id" {
  description = "ID da ACL da rede do elasticache"
  value       = concat(aws_network_acl.elasticache.*.id, [""])[0]
}

# VPC Endpoints
output "vpc_endpoint_s3_id" {
  description = "O ID do VPC Endpoint para o S3"
  value       = concat(aws_vpc_endpoint.s3.*.id, [""])[0]
}

output "vpc_endpoint_s3_pl_id" {
  description = "A lista de prefixos para o VPC Endpoint do S3"
  value       = concat(aws_vpc_endpoint.s3.*.prefix_list_id, [""])[0]
}

output "vpc_endpoint_dynamodb_id" {
  description = "O ID do VPC Endpoint do DynamoDB"
  value       = concat(aws_vpc_endpoint.dynamodb.*.id, [""])[0]
}

output "vpc_endpoint_dynamodb_pl_id" {
  description = "A lista de prefixos para o VPC Endpoint do DynamoDB"
  value       = concat(aws_vpc_endpoint.dynamodb.*.prefix_list_id, [""])[0]
}

output "vpc_endpoint_sqs_id" {
  description = "O ID do VPC Endpoint do SQS"
  value       = "${element(concat(aws_vpc_endpoint.sqs.*.id, list("")), 0)}"
}

output "vpc_endpoint_sqs_network_interface_ids" {
  description = "Uma ou mais interfaces de rede para o VPC Endpoint do SQS."
  value       = "${flatten(aws_vpc_endpoint.sqs.*.network_interface_ids)}"
}

output "vpc_endpoint_sqs_dns_entry" {
  description = "As entradas DNS para o VPC Endpoint do SQS"
  value       = "${flatten(aws_vpc_endpoint.sqs.*.dns_entry)}"
}

output "vpc_endpoint_ssm_id" {
  description = "O ID do VPC Endpoint da VPC para SSM"
  value       = concat(aws_vpc_endpoint.ssm.*.id, [""])[0]
}

output "vpc_endpoint_ssm_network_interface_ids" {
  description = "Uma ou mais interfaces de rede para o VPC Endpoint do SSM."
  value       = flatten(aws_vpc_endpoint.ssm.*.network_interface_ids)
}

output "vpc_endpoint_ssm_dns_entry" {
  description = "As entradas DNS para o VPC Endpoint do SSM."
  value       = flatten(aws_vpc_endpoint.ssm.*.dns_entry)
}

output "vpc_endpoint_ssmmessages_id" {
  description = "O ID do VPC Endpoint da VPC para SSMMESSAGES"
  value       = concat(aws_vpc_endpoint.ssmmessages.*.id, [""])[0]
}

output "vpc_endpoint_ssmmessages_network_interface_ids" {
  description = "Uma ou mais interfaces de rede para o VPC Endpoint do SSMMESSAGES."
  value       = flatten(aws_vpc_endpoint.ssmmessages.*.network_interface_ids)
}

output "vpc_endpoint_ssmmessages_dns_entry" {
  description = "As entradas DNS para o ponto de extremidade da VPC para SSMMESSAGES."
  value       = flatten(aws_vpc_endpoint.ssmmessages.*.dns_entry)
}

output "vpc_endpoint_ec2_id" {
  description = "O ID do terminal da VPC para EC2"
  value       = concat(aws_vpc_endpoint.ec2.*.id, [""])[0]
}

output "vpc_endpoint_ec2_network_interface_ids" {
  description = "Uma ou mais interfaces de rede para o VPC Endpoint for EC2"
  value       = flatten(aws_vpc_endpoint.ec2.*.network_interface_ids)
}

output "vpc_endpoint_ec2_dns_entry" {
  description = "As entradas DNS para o VPC Endpoint para EC2."
  value       = flatten(aws_vpc_endpoint.ec2.*.dns_entry)
}

output "vpc_endpoint_ec2messages_id" {
  description = "O ID do VPC Endpoint para EC2MESSAGES"
  value       = concat(aws_vpc_endpoint.ec2messages.*.id, [""])[0]
}

output "vpc_endpoint_ec2messages_network_interface_ids" {
  description = "Uma ou mais interfaces de rede para o VPC Endpoint da EC2MESSAGES"
  value       = flatten(aws_vpc_endpoint.ec2messages.*.network_interface_ids)
}

output "vpc_endpoint_ec2messages_dns_entry" {
  description = "As entradas DNS para o VPC Endpoint da EC2MESSAGES."
  value       = flatten(aws_vpc_endpoint.ec2messages.*.dns_entry)
}

output "vpc_endpoint_kms_id" {
  description = "O ID do VPC Endpoint para KMS"
  value       = concat(aws_vpc_endpoint.kms.*.id, [""])[0]
}

output "vpc_endpoint_kms_network_interface_ids" {
  description = "As entradas DNS do VPC Endpoint para KMS."
  value       = flatten(aws_vpc_endpoint.kms.*.network_interface_ids)
}

output "vpc_endpoint_kms_dns_entry" {
  description = "As entradas DNS do VPC Endpoint para KMS."
  value       = flatten(aws_vpc_endpoint.kms.*.dns_entry)
}

output "vpc_endpoint_ecr_api_id" {
  description = "O ID do VPC Endpoint para ECR API"
  value       = concat(aws_vpc_endpoint.ecr_api.*.id, [""])[0]
}

output "vpc_endpoint_ecr_api_network_interface_ids" {
  description = "As entradas DNS do VPC Endpoint para ECR API."
  value       = flatten(aws_vpc_endpoint.ecr_api.*.network_interface_ids)
}

output "vpc_endpoint_ecr_api_dns_entry" {
  description = "As entradas DNS do VPC Endpoint para ECR API."
  value       = flatten(aws_vpc_endpoint.ecr_api.*.dns_entry)
}

output "vpc_endpoint_ecr_dkr_id" {
  description = "O ID do VPC Endpoint para ECR DKR"
  value       = concat(aws_vpc_endpoint.ecr_dkr.*.id, [""])[0]
}

output "vpc_endpoint_ecr_dkr_network_interface_ids" {
  description = "As entradas DNS do VPC Endpoint para ECR DKR."
  value       = flatten(aws_vpc_endpoint.ecr_dkr.*.network_interface_ids)
}

output "vpc_endpoint_ecr_dkr_dns_entry" {
  description = "As entradas DNS do VPC Endpoint para ECR DKR."
  value       = flatten(aws_vpc_endpoint.ecr_dkr.*.dns_entry)
}

output "vpc_endpoint_apigw_id" {
  description = "O ID do VPC Endpoint para APIGW"
  value       = concat(aws_vpc_endpoint.apigw.*.id, [""])[0]
}

output "vpc_endpoint_apigw_network_interface_ids" {
  description = "As entradas DNS do VPC Endpoint para APIGW."
  value       = flatten(aws_vpc_endpoint.apigw.*.network_interface_ids)
}

output "vpc_endpoint_apigw_dns_entry" {
  description = "As entradas DNS do VPC Endpoint para APIGW."
  value       = flatten(aws_vpc_endpoint.apigw.*.dns_entry)
}

output "vpc_endpoint_ecs_id" {
  description = "O ID do VPC Endpoint para ECS"
  value       = "${element(concat(aws_vpc_endpoint.ecs.*.id, list("")), 0)}"
}

output "vpc_endpoint_ecs_network_interface_ids" {
  description = "Uma ou mais interfaces de rede do VPC Endpoint para ECS."
  value       = "${flatten(aws_vpc_endpoint.ecs.*.network_interface_ids)}"
}

output "vpc_endpoint_ecs_dns_entry" {
  description = "As entradas DNS do VPC Endpoint para ECS."
  value       = "${flatten(aws_vpc_endpoint.ecs.*.dns_entry)}"
}

output "vpc_endpoint_ecs_agent_id" {
  description = "O ID do VPC endpoint para ECS Agent"
  value       = "${element(concat(aws_vpc_endpoint.ecs_agent.*.id, list("")), 0)}"
}

output "vpc_endpoint_ecs_agent_network_interface_ids" {
  description = "Uma ou mais interfaces de rede do VPC Endpoint para ECS Agent."
  value       = "${flatten(aws_vpc_endpoint.ecs_agent.*.network_interface_ids)}"
}

output "vpc_endpoint_ecs_agent_dns_entry" {
  description = "As entradas DNS do VPC Endpoint para ECS Agent."
  value       = "${flatten(aws_vpc_endpoint.ecs_agent.*.dns_entry)}"
}

output "vpc_endpoint_ecs_telemetry_id" {
  description = "O ID do VPC Endpoint para ECS Telemetry"
  value       = "${element(concat(aws_vpc_endpoint.ecs_telemetry.*.id, list("")), 0)}"
}

output "vpc_endpoint_ecs_telemetry_network_interface_ids" {
  description = "Uma ou mais interfaces de rede do VPC Endpoint para ECS Telemetry."
  value       = "${flatten(aws_vpc_endpoint.ecs_telemetry.*.network_interface_ids)}"
}

output "vpc_endpoint_ecs_telemetry_dns_entry" {
  description = "As entradas DNS do VPC Endpoint para ECS Telemetry."
  value       = "${flatten(aws_vpc_endpoint.ecs_telemetry.*.dns_entry)}"
}

output "vpc_endpoint_sns_id" {
  description = "As entradas DNS do VPC Endpoint para ECS Telemetry"
  value       = concat(aws_vpc_endpoint.sns.*.id, [""])[0]
}

output "vpc_endpoint_sns_network_interface_ids" {
  description = "Uma ou mais interfaces de rede do VPC Endpoint para SNS."
  value       = flatten(aws_vpc_endpoint.sns.*.network_interface_ids)
}

output "vpc_endpoint_sns_dns_entry" {
  description = "As entradas DNS do VPC Endpoint para SNS"
  value       = flatten(aws_vpc_endpoint.sns.*.dns_entry)
}

output "vpc_endpoint_monitoring_id" {
  description = "O ID do VPC Endpoint para o Monitoramento CloudWatch"
  value       = concat(aws_vpc_endpoint.monitoring.*.id, [""])[0]
}

output "vpc_endpoint_monitoring_network_interface_ids" {
  description = "Uma ou mais interfaces de rede do VPC Endpoint para CloudWatch Monitoring."
  value       = flatten(aws_vpc_endpoint.monitoring.*.network_interface_ids)
}

output "vpc_endpoint_monitoring_dns_entry" {
  description = "As entradas DNS do VPC Endpoint para CloudWatch Monitoring."
  value       = flatten(aws_vpc_endpoint.monitoring.*.dns_entry)
}

output "vpc_endpoint_logs_id" {
  description = "O ID do VPC Endpoint para logs do CloudWatch"
  value       = concat(aws_vpc_endpoint.logs.*.id, [""])[0]
}

output "vpc_endpoint_logs_network_interface_ids" {
  description = "Uma ou mais interfaces de rede do VPC Endpoint para CloudWatch Logs."
  value       = flatten(aws_vpc_endpoint.logs.*.network_interface_ids)
}

output "vpc_endpoint_logs_dns_entry" {
  description = "As entradas DNS do VPC Endpoint para CloudWatch Logs."
  value       = flatten(aws_vpc_endpoint.logs.*.dns_entry)
}

output "vpc_endpoint_events_id" {
  description = "O ID do VPC Endpoint para eventos do CloudWatch"
  value       = concat(aws_vpc_endpoint.events.*.id, [""])[0]
}

output "vpc_endpoint_events_network_interface_ids" {
  description = "Uma ou mais interfaces de rede do VPC Endpoint para CloudWatch Events."
  value       = flatten(aws_vpc_endpoint.events.*.network_interface_ids)
}

output "vpc_endpoint_events_dns_entry" {
  description = "As entradas DNS do VPC Endpoint para CloudWatch Events."
  value       = flatten(aws_vpc_endpoint.events.*.dns_entry)
}

output "vpc_endpoint_elasticloadbalancing_id" {
  description = "O ID do VPC Endpoint para o Elastic Load Balancing"
  value       = concat(aws_vpc_endpoint.elasticloadbalancing.*.id, [""])[0]
}

output "vpc_endpoint_elasticloadbalancing_network_interface_ids" {
  description = "Uma ou mais interfaces de rede do VPC Endpoint para Elastic Load Balancing."
  value       = flatten(aws_vpc_endpoint.elasticloadbalancing.*.network_interface_ids)
}

output "vpc_endpoint_elasticloadbalancing_dns_entry" {
  description = "As entradas DNS para o VPC Endpoint para Elastic Load Balancing."
  value       = flatten(aws_vpc_endpoint.elasticloadbalancing.*.dns_entry)
}

output "vpc_endpoint_cloudtrail_id" {
  description = "O ID do VPC Endpoint para CloudTrail"
  value       = concat(aws_vpc_endpoint.cloudtrail.*.id, [""])[0]
}

output "vpc_endpoint_cloudtrail_network_interface_ids" {
  description = "Uma ou mais interfaces de rede do VPC Endpoint para CloudTrail."
  value       = flatten(aws_vpc_endpoint.cloudtrail.*.network_interface_ids)
}

output "vpc_endpoint_cloudtrail_dns_entry" {
  description = "As entradas DNS do VPC Endpoint para CloudTrail."
  value       = flatten(aws_vpc_endpoint.cloudtrail.*.dns_entry)
}

# Valores estáticos (argumentos)
output "azs" {
  description = "Uma lista de zonas de disponibilidade especificadas como argumento para este módulo"
  value       = var.azs
}

