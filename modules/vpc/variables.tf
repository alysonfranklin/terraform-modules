variable "create_vpc" {
  description = "Controla se a VPC deve ser criada (afeta quase todos os recursos)"
  type        = bool
  default     = true
}

variable "name" {
  description = "Nome a ser usado em todos os recursos como identificador"
  default     = ""
}

variable "cidr" {
  description = "O bloco CIDR para a VPC. O valor padrão é um CIDR válido, mas não é aceitável pela AWS e deve ser substituído"
  default     = "0.0.0.0/0"
}

variable "assign_generated_ipv6_cidr_block" {
  description = "Solicita um bloco CIDR IPv6 fornecido pela Amazon com um comprimento de prefixo / 56 para a VPC. Você não pode especificar o intervalo de endereços IP ou o tamanho do bloco CIDR"
  type        = bool
  default     = false
}

variable "secondary_cidr_blocks" {
  description = "Lista de blocos CIDR secundários a serem associados à VPC para estender o pool de endereços IP"
  type        = list(string)
  default     = []
}

variable "instance_tenancy" {
  description = "Uma opção de locação para instâncias iniciadas no VPC"
  type        = string
  default     = "default"
}

variable "public_subnet_suffix" {
  description = "Sufixo para anexar ao nome de sub-redes públicas"
  type        = string
  default     = "public"
}

variable "private_subnet_suffix" {
  description = "Sufixo para anexar ao nome de sub-redes privadas"
  type        = string
  default     = "private"
}

variable "intra_subnet_suffix" {
  description = "Sufixo para anexar ao nome das sub-redes"
  type        = string
  default     = "intra"
}

variable "database_subnet_suffix" {
  description = "Sufixo para anexar ao nome das sub-redes do banco de dados"
  type        = string
  default     = "db"
}

variable "redshift_subnet_suffix" {
  description = "Sufixo para anexar ao nome das sub-redes do Redshift"
  type        = string
  default     = "redshift"
}

variable "elasticache_subnet_suffix" {
  description = "Sufixo para anexar ao nome das sub-redes do elasticache"
  type        = string
  default     = "elasticache"
}

variable "public_subnets" {
  description = "Uma lista de sub-redes públicas dentro da VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "Uma lista de sub-redes privadas dentro da VPC"
  type        = list(string)
  default     = []
}

variable "database_subnets" {
  description = "Uma lista de sub-redes de banco de dados"
  type        = list(string)
  default     = []
}

variable "redshift_subnets" {
  description = "Uma lista de sub-redes de redshift"
  type        = list(string)
  default     = []
}

variable "elasticache_subnets" {
  description = "Uma lista de sub-redes de elasticache"
  type        = list(string)
  default     = []
}

variable "intra_subnets" {
  description = "Uma lista de sub-redes de intra"
  type        = list(string)
  default     = []
}

variable "create_database_subnet_route_table" {
  description = "Controla se a tabela de rota separada para o banco de dados deve ser criada"
  type        = bool
  default     = false
}

variable "create_redshift_subnet_route_table" {
  description = "Controla se a tabela de rota separada para o Redshift deve ser criada"
  type        = bool
  default     = false
}

variable "enable_public_redshift" {
  description = "Controla se o redshift deve ter uma tabela de roteamento pública"
  type        = bool
  default     = false
}

variable "create_elasticache_subnet_route_table" {
  description = "Controla se a tabela de rota separada para elasticache deve ser criada"
  type        = bool
  default     = false
}

variable "create_database_subnet_group" {
  description = "Controla se a tabela de rota separada para elasticache deve ser criada"
  type        = bool
  default     = true
}

variable "create_elasticache_subnet_group" {
  description = "Controla se o grupo de sub-redes elasticache deve ser criado"
  type        = bool
  default     = true
}

variable "create_redshift_subnet_group" {
  description = "Controla se o grupo de sub-redes redshift deve ser criado"
  type        = bool
  default     = true
}

variable "create_database_internet_gateway_route" {
  description = "Controla se o grupo de sub-redes redshift deve ser criado"
  type        = bool
  default     = false
}

variable "create_database_nat_gateway_route" {
  description = "Os controles de uma rota de gateway nat devem ser criados para fornecer acesso à Internet às sub-redes do banco de dados"
  type        = bool
  default     = false
}

variable "azs" {
  description = "Uma lista de zonas de disponibilidade na região"
  type        = list(string)
  default     = []
}

variable "enable_dns_hostnames" {
  description = "Deve ser verdadeiro para habilitar nomes de host DNS na VPC"
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = "Deve ser verdadeiro para ativar o suporte ao DNS no VPC"
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "Deve ser verdadeiro se você deseja provisionar NAT Gateways para cada uma das suas redes privadas"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Deve ser verdadeiro se você deseja provisionar um único NAT Gateways compartilhado em todas as suas redes privadas"
  type        = bool
  default     = false
}

variable "one_nat_gateway_per_az" {
  description = "Deve ser verdadeiro se você deseja apenas um Gateway NAT por zona de disponibilidade. Requer que `var.azs` seja definido, e o número de` public_subnets` criado seja maior ou igual ao número de zonas de disponibilidade especificadas em `var.azs`."
  type        = bool
  default     = false
}

variable "reuse_nat_ips" {
  description = "Deve ser verdadeiro se você não deseja que os EIPs sejam criados para seus NAT Gateways e os repassará por meio da variável 'nat_ip_ids' externa"
  type        = bool
  default     = false
}

variable "external_nat_ip_ids" {
  description = "Lista de IDs EIP a serem atribuídos aos NAT Gateways (usados em combinação com reuse_nat_ips)"
  type        = list(string)
  default     = []
}

variable "enable_dynamodb_endpoint" {
  description = "Deve ser verdadeiro se você deseja provisionar um VPC Endpoint para o DynamoDB"
  type        = bool
  default     = false
}

variable "enable_s3_endpoint" {
  description = "Deve ser verdadeiro se você deseja provisionar um VPC Endpoint para o S3"
  type        = bool
  default     = false
}

variable "enable_sqs_endpoint" {
  description = "Deve ser verdadeiro se você deseja provisionar um VPC Endpoint para SQS"
  default     = false
}

variable "sqs_endpoint_security_group_ids" {
  description = "O ID de um ou mais grupos de segurança a serem associados à interface de rede para o Endpoint SQS"
  default     = []
}

variable "sqs_endpoint_subnet_ids" {
  description = "O ID de uma ou mais sub-redes nas quais criar uma interface de rede para o Endpoint SQS. Apenas uma única sub-rede em um AZ é suportada. Se omitido, sub-redes privadas serão usadas."
  default     = []
}

variable "sqs_endpoint_private_dns_enabled" {
  description = "Se deve ou não associar uma zona privada ao VPC Endpoint para SQS especificado"
  default     = false
}

variable "enable_ssm_endpoint" {
  description = "Deve ser verdadeiro se você deseja provisionar um VPC Endpoint para SSM"
  type        = bool
  default     = false
}

variable "ssm_endpoint_security_group_ids" {
  description = "O ID de um ou mais grupos de segurança a serem associados à interface de rede para o VPC Endpoint SSM"
  type        = list(string)
  default     = []
}

variable "ssm_endpoint_subnet_ids" {
  description = "O ID de uma ou mais sub-redes nas quais criar uma interface de rede para o VPC Endpoint SSM. Apenas uma única sub-rede em um AZ é suportada. Se omitido, sub-redes privadas serão usadas."
  type        = list(string)
  default     = []
}

variable "ssm_endpoint_private_dns_enabled" {
  description = "Se deve ou não associar uma zona privada ao VPC Endpoint especificado para SSM"
  type        = bool
  default     = false
}

variable "enable_ssmmessages_endpoint" {
  description = "Deve ser verdadeiro se você deseja provisionar um VPC Endpoint para SSMMESSAGES"
  type        = bool
  default     = false
}

variable "enable_apigw_endpoint" {
  description = "Deve ser verdadeiro se você deseja provisionar um VPC Endpoint de Api Gateway"
  type        = bool
  default     = false
}

variable "apigw_endpoint_security_group_ids" {
  description = "O ID de um ou mais grupos de segurança a serem associados à interface de rede para o VPC Endpoint da API Gateway"
  type        = list(string)
  default     = []
}

variable "apigw_endpoint_private_dns_enabled" {
  description = "Se deve ou não associar uma zona privada ao VPC Endpoint especificado para API Gateway"
  type        = bool
  default     = false
}

variable "apigw_endpoint_subnet_ids" {
  description = "O ID de uma ou mais sub-redes nas quais criar uma interface de rede para o VPC Endpoint da API Gateway. Apenas uma única sub-rede em um AZ é suportada. Se omitido, sub-redes privadas serão usadas."
  type        = list(string)
  default     = []
}

variable "ssmmessages_endpoint_security_group_ids" {
  description = "O ID de um ou mais grupos de segurança a serem associados à interface de rede para o VPC Endpoint SSMMESSAGES"
  type        = list(string)
  default     = []
}

variable "ssmmessages_endpoint_subnet_ids" {
  description = "O ID de uma ou mais sub-redes nas quais criar uma interface de rede para o VPC Endpoint SSMMESSAGES. Apenas uma única sub-rede em um AZ é suportada. Se omitido, sub-redes privadas serão usadas."
  type        = list(string)
  default     = []
}

variable "ssmmessages_endpoint_private_dns_enabled" {
  description = "Se deve ou não associar uma zona privada ao VPC Endpoint especificado para SSMMESSAGES"
  type        = bool
  default     = false
}

variable "enable_ec2_endpoint" {
  description = "Deve ser verdadeiro se você deseja provisionar um VPC Endpoint para EC2"
  type        = bool
  default     = false
}

variable "ec2_endpoint_security_group_ids" {
  description = "O ID de um ou mais grupos de segurança a serem associados à interface de rede para o VPC Endpoint EC2"
  type        = list(string)
  default     = []
}

variable "ec2_endpoint_private_dns_enabled" {
  description = "Se deve ou não associar uma zona privada ao VPC Endpoint especificado para EC2"
  type        = bool
  default     = false
}

variable "ec2_endpoint_subnet_ids" {
  description = "O ID de uma ou mais sub-redes nas quais criar uma interface de rede para o VPC Endpoint do EC2. Apenas uma única sub-rede em um AZ é suportada. Se omitido, sub-redes privadas serão usadas."
  type        = list(string)
  default     = []
}

variable "enable_ec2messages_endpoint" {
  description = "Deve ser verdadeiro se você deseja provisionar um VPC Endpoint para EC2MESSAGES"
  type        = bool
  default     = false
}

variable "ec2messages_endpoint_security_group_ids" {
  description = "O ID de um ou mais grupos de segurança a serem associados à interface de rede para o VPC Endpoint EC2MESSAGES"
  type        = list(string)
  default     = []
}

variable "ec2messages_endpoint_private_dns_enabled" {
  description = "Se deve ou não associar uma zona privada ao VPC Endpoint especificado da EC2MESSAGES"
  type        = bool
  default     = false
}

variable "ec2messages_endpoint_subnet_ids" {
  description = "O ID de uma ou mais sub-redes nas quais criar uma interface de rede para o VPC Endpoint EC2MESSAGES. Apenas uma única sub-rede em um AZ é suportada. Se omitido, sub-redes privadas serão usadas."
  type        = list(string)
  default     = []
}

variable "enable_ecr_api_endpoint" {
  description = "Deve ser verdadeiro se você deseja provisionar um VPC Endpoint para o ECR"
  type        = bool
  default     = false
}

variable "ecr_api_endpoint_subnet_ids" {
  description = "O ID de uma ou mais sub-redes nas quais criar uma interface de rede para o VPC Endpoint da API ECR. Se omitido, sub-redes privadas serão usadas."
  type        = list(string)
  default     = []
}

variable "ecr_api_endpoint_private_dns_enabled" {
  description = "Se deve ou não associar uma zona privada ao VPC Endpoint da API do EKS"
  type        = bool
  default     = false
}

variable "ecr_api_endpoint_security_group_ids" {
  description = "O ID de um ou mais grupos de segurança a serem associados à interface de rede para o VPC Endpoint da API ECR"
  type        = list(string)
  default     = []
}

variable "enable_ecr_dkr_endpoint" {
  description = "Deve ser verdadeiro se você deseja provisionar um VPC Endpoint ECR Dkr para o VPC"
  type        = bool
  default     = false
}

variable "ecr_dkr_endpoint_subnet_ids" {
  description = "O ID de uma ou mais sub-redes nas quais criar uma interface de rede para VPC Endpoint ECR dkr. Se omitido, sub-redes privadas serão usadas."
  type        = list(string)
  default     = []
}

variable "ecr_dkr_endpoint_private_dns_enabled" {
  description = "Se deve ou não associar uma zona privada ao VPC Endpoint especificado para ECR DKR"
  type        = bool
  default     = false
}

variable "ecr_dkr_endpoint_security_group_ids" {
  description = "O ID de um ou mais grupos de segurança a serem associados à interface de rede para o VPC Endpoint ECR DKR"
  type        = list(string)
  default     = []
}

variable "enable_kms_endpoint" {
  description = "Deve ser verdadeiro se você deseja provisionar um VPC Endpoint para KMS"
  type        = bool
  default     = false
}

variable "kms_endpoint_security_group_ids" {
  description = "O ID de um ou mais grupos de segurança a serem associados à interface de rede para o VPC Endpoint KMS"
  type        = list(string)
  default     = []
}

variable "kms_endpoint_subnet_ids" {
  description = "O ID de uma ou mais sub-redes nas quais criar uma interface de rede para o terminal KMS. Apenas uma única sub-rede em um AZ é suportada. Se omitido, sub-redes privadas serão usadas."
  type        = list(string)
  default     = []
}

variable "kms_endpoint_private_dns_enabled" {
  description = "Se deve ou não associar uma zona privada ao VPC Endpoint especificado do KMS"
  type        = bool
  default     = false
}

variable "enable_ecs_endpoint" {
  description = "Deve ser verdadeiro se você deseja provisionar um VPC Endpoint para ECS"
  type        = bool
  default     = false
}

variable "ecs_endpoint_security_group_ids" {
  description = "O ID de um ou mais grupos de segurança a serem associados à interface de rede para o VPC Endpoint do ECS"
  type        = list(string)
  default     = []
}

variable "ecs_endpoint_subnet_ids" {
  description = "O ID de uma ou mais sub-redes nas quais criar uma interface de rede para o VPC Endpoint do ECS. Apenas uma única sub-rede em um AZ é suportada. Se omitido, sub-redes privadas serão usadas."
  type        = list(string)
  default     = []
}

variable "ecs_endpoint_private_dns_enabled" {
  description = "Se deve ou não associar uma zona privada ao VPC Endpoint especificado do ECS"
  type        = bool
  default     = false
}

variable "enable_ecs_agent_endpoint" {
  description = "Deve ser verdadeiro se você deseja provisionar um VPC Endpoint do ECS Agent"
  type        = bool
  default     = false
}

variable "ecs_agent_endpoint_security_group_ids" {
  description = "O ID de um ou mais grupos de segurança a serem associados à interface de rede para o VPC Endpoint do ECS Agent"
  type        = list(string)
  default     = []
}

variable "ecs_agent_endpoint_subnet_ids" {
  description = "O ID de uma ou mais sub-redes nas quais criar uma interface de rede para o VPC Endpoint do ECS Agent. Apenas uma única sub-rede em um AZ é suportada. Se omitido, sub-redes privadas serão usadas."
  type        = list(string)
  default     = []
}

variable "ecs_agent_endpoint_private_dns_enabled" {
  description = "Se deve ou não associar uma zona privada ao VPC Endpoint especificado do ECS Agent"
  type        = bool
  default     = false
}

variable "enable_ecs_telemetry_endpoint" {
  description = "Deve ser verdadeiro se você deseja provisionar um VPC Endpoint de Telemetria ECS"
  type        = bool
  default     = false
}

variable "ecs_telemetry_endpoint_security_group_ids" {
  description = "O ID de um ou mais grupos de segurança a serem associados à interface de rede para o VPC Endpoint do ECS Telemetry"
  type        = list(string)
  default     = []
}

variable "ecs_telemetry_endpoint_subnet_ids" {
  description = "O ID de uma ou mais sub-redes nas quais criar uma interface de rede para o VPC Endpoint de Telemetria do ECS. Apenas uma única sub-rede em um AZ é suportada. Se omitido, sub-redes privadas serão usadas."
  type        = list(string)
  default     = []
}

variable "ecs_telemetry_endpoint_private_dns_enabled" {
  description = "Se deve ou não associar uma zona privada ao VPC Endpoint do ECS especificado"
  type        = bool
  default     = false
}

variable "enable_sns_endpoint" {
  description = "Deve ser verdadeiro se você deseja provisionar um ponto VPC Endpoint o SNS"
  type        = bool
  default     = false
}

variable "sns_endpoint_security_group_ids" {
  description = "O ID de um ou mais grupos de segurança a serem associados à interface de rede para o VPC Endpoint SNS"
  type        = list(string)
  default     = []
}

variable "sns_endpoint_subnet_ids" {
  description = "O ID de uma ou mais sub-redes nas quais criar uma interface de rede para o VPC Endpoint do SNS. Apenas uma única sub-rede em um AZ é suportada. Se omitido, sub-redes privadas serão usadas."
  type        = list(string)
  default     = []
}

variable "sns_endpoint_private_dns_enabled" {
  description = "Se deve ou não associar uma zona privada ao VPC Endpoint para o SNS especificado"
  type        = bool
  default     = false
}

variable "enable_monitoring_endpoint" {
  description = "Deve ser verdadeiro se você deseja provisionar um VPC Endpoint do CloudWatch Monitoring"
  type        = bool
  default     = false
}

variable "monitoring_endpoint_security_group_ids" {
  description = "O ID de um ou mais grupos de segurança a serem associados à interface de rede para o VPC Endpoint do CloudWatch Monitoring"
  type        = list(string)
  default     = []
}

variable "monitoring_endpoint_subnet_ids" {
  description = "O ID de uma ou mais sub-redes nas quais criar uma interface de rede para o VPC Endpoint do CloudWatch Monitoring. Apenas uma única sub-rede em um AZ é suportada. Se omitido, sub-redes privadas serão usadas."
  type        = list(string)
  default     = []
}

variable "monitoring_endpoint_private_dns_enabled" {
  description = "Se deve ou não associar uma zona privada ao VPC Endpoint especificado para Monitoramento do CloudWatch"
  type        = bool
  default     = false
}

variable "enable_elasticloadbalancing_endpoint" {
  description = "Deve ser verdadeiro se você deseja provisionar um ponto de extremidade do Elastic Load Balancing para a VPC"
  type        = bool
  default     = false
}

variable "elasticloadbalancing_endpoint_security_group_ids" {
  description = "O ID de um ou mais grupos de segurança a serem associados à interface de rede para o VPC Endpoint do Elastic Load Balancing"
  type        = list(string)
  default     = []
}

variable "elasticloadbalancing_endpoint_subnet_ids" {
  description = "O ID de uma ou mais sub-redes nas quais criar uma interface de rede para o VPC Endpoint do Elastic Load Balancing. Apenas uma única sub-rede com em um AZ é suportada. Se omitido, sub-redes privadas serão usadas."
  type        = list(string)
  default     = []
}

variable "elasticloadbalancing_endpoint_private_dns_enabled" {
  description = "Se deve ou não associar uma zona privada ao VPC Endpoint especificado para Elastic Load Balancing"
  type        = bool
  default     = false
}

variable "enable_events_endpoint" {
  description = "Deve ser verdadeiro se você deseja provisionar um VPC Endpoint de Eventos do CloudWatch para o VPC"
  type        = bool
  default     = false
}

variable "events_endpoint_security_group_ids" {
  description = "O ID de um ou mais grupos de segurança a serem associados à interface de rede para o VPC Endpoint do CloudWatch Events"
  type        = list(string)
  default     = []
}

variable "events_endpoint_subnet_ids" {
  description = "O ID de uma ou mais sub-redes nas quais criar uma interface de rede para o VPC Endpoint do CloudWatch Events. Apenas uma única sub-rede em um AZ é suportada. Se omitido, sub-redes privadas serão usadas."
  type        = list(string)
  default     = []
}

variable "events_endpoint_private_dns_enabled" {
  description = "Se deve ou não associar uma zona privada ao VPC Endpoint especificado do CloudWatch Events"
  type        = bool
  default     = false
}

variable "enable_logs_endpoint" {
  description = "Deve ser verdadeiro se você deseja provisionar um VPC Endpoint do CloudWatch Logs para a VPC"
  type        = bool
  default     = false
}

variable "logs_endpoint_security_group_ids" {
  description = "O ID de um ou mais grupos de segurança a serem associados à interface de rede para o VPC Endpoint do CloudWatch Logs"
  type        = list(string)
  default     = []
}

variable "logs_endpoint_subnet_ids" {
  description = "O ID de uma ou mais sub-redes nas quais criar uma interface de rede para o VPC Endpoint CloudWatch Logs. Apenas uma única sub-rede dentro de um Z é suportada. Se omitido, sub-redes privadas serão usadas."
  type        = list(string)
  default     = []
}

variable "logs_endpoint_private_dns_enabled" {
  description = "Se deve ou não associar uma zona privada ao VPC Endpoint especificado para CloudWatch Logs"
  type        = bool
  default     = false
}

variable "enable_cloudtrail_endpoint" {
  description = "Deve ser verdadeiro se você deseja provisionar um VPC Endpoint para CloudTrail"
  type        = bool
  default     = false
}

variable "cloudtrail_endpoint_security_group_ids" {
  description = "O ID de um ou mais grupos de segurança a serem associados à interface de rede para o VPC Endpoint do CloudTrail"
  type        = list(string)
  default     = []
}

variable "cloudtrail_endpoint_subnet_ids" {
  description = "O ID de uma ou mais sub-redes nas quais criar uma interface de rede para VPC Endpoint do CloudTrail. Apenas uma única sub-rede em um AZ é suportada. Se omitido, sub-redes privadas serão usadas."
  type        = list(string)
  default     = []
}

variable "cloudtrail_endpoint_private_dns_enabled" {
  description = "Se deve ou não associar uma zona privada ao VPC Endpoint especificado para CloudTrail"
  type        = bool
  default     = false
}

variable "map_public_ip_on_launch" {
  description = "Deve ser falso se você não deseja atribuir automaticamente IP público ao iniciar"
  type        = bool
  default     = true
}

variable "enable_vpn_gateway" {
  description = "Deve ser verdadeiro se você deseja criar um novo recurso de VPN Gateway e anexá-lo à VPC"
  type        = bool
  default     = false
}

variable "vpn_gateway_id" {
  description = "ID do VPN Gateway a ser anexado à VPC"
  default     = ""
}

variable "amazon_side_asn" {
  description = "O número do sistema autônomo (ASN) do lado do gateway da amazon. Por padrão, o gateway privado virtual é criado com o Amazon ASN padrão atual"
  default     = "64512"
}

variable "propagate_private_route_tables_vgw" {
  description = "Deve ser verdadeiro se você desejar a propagação da tabela de rotas"
  type        = bool
  default     = false
}

variable "propagate_public_route_tables_vgw" {
  description = "Deve ser verdadeiro se você desejar a propagação da tabela de rotas"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Um mapa de tags para adicionar a todos os recursos"
  type        = map(string)
  default     = {}
}

variable "vpc_tags" {
  description = "Tags adicionais para a VPC"
  type        = map(string)
  default     = {}
}

variable "igw_tags" {
  description = "Tags adicionais para o gateway da Internet"
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "Tags adicionais para as sub-redes públicas"
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Tags adicionais para as sub-redes privadas"
  type        = map(string)
  default     = {}
}

variable "public_route_table_tags" {
  description = "Tags adicionais para as tabelas de rotas públicas"
  type        = map(string)
  default     = {}
}

variable "private_route_table_tags" {
  description = "Tags adicionais para as tabelas de rotas particulares"
  type        = map(string)
  default     = {}
}

variable "database_route_table_tags" {
  description = "Tags adicionais para as tabelas de rotas do banco de dados"
  type        = map(string)
  default     = {}
}

variable "redshift_route_table_tags" {
  description = "Tags adicionais para as tabelas de rotas de desvio para o Redshift"
  type        = map(string)
  default     = {}
}

variable "elasticache_route_table_tags" {
  description = "Tags adicionais para as tabelas de rotas elasticache"
  type        = map(string)
  default     = {}
}

variable "intra_route_table_tags" {
  description = "Tags adicionais para as tabelas de rotas internas"
  type        = map(string)
  default     = {}
}

variable "database_subnet_tags" {
  description = "Tags adicionais para as sub-redes do banco de dados"
  type        = map(string)
  default     = {}
}

variable "database_subnet_group_tags" {
  description = "Tags adicionais para o grupo de sub-rede do banco de dados"
  type        = map(string)
  default     = {}
}

variable "redshift_subnet_tags" {
  description = "Tags adicionais para as sub-redes de desvio para o Redshift"
  type        = map(string)
  default     = {}
}

variable "redshift_subnet_group_tags" {
  description = "Tags adicionais para o grupo de sub-rede redshift"
  type        = map(string)
  default     = {}
}

variable "elasticache_subnet_tags" {
  description = "Tags adicionais para as sub-redes elasticache"
  type        = map(string)
  default     = {}
}

variable "intra_subnet_tags" {
  description = "Tags adicionais para as sub-redes intra"
  type        = map(string)
  default     = {}
}

variable "public_acl_tags" {
  description = "Tags adicionais para a rede publica de sub-redes ACL"
  type        = map(string)
  default     = {}
}

variable "private_acl_tags" {
  description = "Tags adicionais para a rede privada de sub-redes ACL"
  type        = map(string)
  default     = {}
}

variable "intra_acl_tags" {
  description = "Tags adicionais para a rede ACL de sub-redes do intra"
  type        = map(string)
  default     = {}
}

variable "database_acl_tags" {
  description = "Tags adicionais para a rede ACL de sub-redes do banco de dados"
  type        = map(string)
  default     = {}
}

variable "redshift_acl_tags" {
  description = "Tags adicionais para a rede ACL da rede de sub-redes redshift"
  type        = map(string)
  default     = {}
}

variable "elasticache_acl_tags" {
  description = "Tags adicionais para a rede ACL de sub-redes elasticache"
  type        = map(string)
  default     = {}
}

variable "dhcp_options_tags" {
  description = "Tags adicionais para o conjunto de opções DHCP (requer ativar as opções dhcp definidas como true)"
  type        = map(string)
  default     = {}
}

variable "nat_gateway_tags" {
  description = "Tags adicionais para o NAT gateways"
  type        = map(string)
  default     = {}
}

variable "nat_eip_tags" {
  description = "Tags adicionais para o NAT EIP"
  type        = map(string)
  default     = {}
}

variable "vpn_gateway_tags" {
  description = "Tags adicionais para o VPN Gateway"
  type        = map(string)
  default     = {}
}

variable "enable_dhcp_options" {
  description = "Deve ser verdadeiro se você desejar especificar opções de DHCP definidas com um nome de domínio personalizado, servidores DNS, servidores NTP, servidores netbios e/ou tipo de servidor netbios"
  type        = bool
  default     = false
}

variable "dhcp_options_domain_name" {
  description = "Especifica o nome DNS para o conjunto de opções DHCP (requer enable_dhcp_options definido como true)"
  type        = string
  default     = ""
}

variable "dhcp_options_domain_name_servers" {
  description = "Especifique uma lista de endereços de servidor DNS para o conjunto de opções DHCP, padrão para a AWS fornecida (requer ativar opções dhcp definidas como true)"
  type        = list(string)
  default     = ["AmazonProvidedDNS"]
}

variable "dhcp_options_ntp_servers" {
  description = "Especifique uma lista de servidores NTP para o conjunto de opções DHCP (requer enable_dhcp_options configurado como true)"
  type        = list(string)
  default     = []
}

variable "dhcp_options_netbios_name_servers" {
  description = "Especifique uma lista de servidores netbios para o conjunto de opções DHCP (requer enable_dhcp_options configurado como true)"
  type        = list(string)
  default     = []
}

variable "dhcp_options_netbios_node_type" {
  description = "Especifique netbios node_type para o conjunto de opções DHCP (requer enable_dhcp_options configurado como true)"
  type        = string
  default     = ""
}

variable "manage_default_vpc" {
  description = "Deve ser verdadeiro adotar e gerenciar a VPC padrão"
  type        = bool
  default     = false
}

variable "default_vpc_name" {
  description = "Nome a ser usado na VPC Padrão"
  type        = string
  default     = ""
}

variable "default_vpc_enable_dns_support" {
  description = "Deve ser verdadeiro para ativar o suporte ao DNS na VPC padrão"
  type        = bool
  default     = true
}

variable "default_vpc_enable_dns_hostnames" {
  description = "Deve ser verdadeiro para habilitar nomes de host DNS na VPC padrão"
  type        = bool
  default     = false
}

variable "default_vpc_enable_classiclink" {
  description = "Deve ser verdadeiro ativar o ClassicLink na VPC padrão"
  type        = bool
  default     = false
}

variable "default_vpc_tags" {
  description = "Tags adicionais para a VPC padrão"
  type        = map(string)
  default     = {}
}

variable "manage_default_network_acl" {
  description = "Deve ser verdadeiro adotar e gerenciar a ACL de rede padrão"
  type        = bool
  default     = false
}

variable "default_network_acl_name" {
  description = "Nome a ser usado na ACL de rede padrão"
  type        = string
  default     = ""
}

variable "default_network_acl_tags" {
  description = "Tags adicionais para a ACL de rede padrão"
  type        = map(string)
  default     = {}
}

variable "public_dedicated_network_acl" {
  description = "Se deve usar ACL de rede dedicada (não padrão) e regras personalizadas para sub-redes públicas"
  type        = bool
  default     = false
}

variable "private_dedicated_network_acl" {
  description = "Se deve usar ACL de rede dedicada (não padrão) e regras personalizadas para sub-redes privadas"
  type        = bool
  default     = false
}

variable "intra_dedicated_network_acl" {
  description = "Se deve usar ACL de rede dedicada (não padrão) e regras personalizadas para sub-redes"
  type        = bool
  default     = false
}

variable "database_dedicated_network_acl" {
  description = "Se deve usar ACL de rede dedicada (não padrão) e regras personalizadas para sub-redes de banco de dados"
  type        = bool
  default     = false
}

variable "redshift_dedicated_network_acl" {
  description = "Se deve usar ACL de rede dedicada (não padrão) e regras personalizadas para sub-redes redshift"
  type        = bool
  default     = false
}

variable "elasticache_dedicated_network_acl" {
  description = "Se deve usar ACL de rede dedicada (não padrão) e regras personalizadas para sub-redes elasticache"
  type        = bool
  default     = false
}

variable "default_network_acl_ingress" {
  description = "Lista de mapas de regras de entrada a serem definidas na ACL da Rede Padrão"
  type        = list(map(string))

  default = [
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no         = 101
      action          = "allow"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      ipv6_cidr_block = "::/0"
    },
  ]
}

variable "default_network_acl_egress" {
  description = "Lista de mapas de regras de saída a serem definidas na ACL da Rede Padrão"
  type        = list(map(string))

  default = [
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no         = 101
      action          = "allow"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      ipv6_cidr_block = "::/0"
    },
  ]
}

variable "public_inbound_acl_rules" {
  description = "ACLs de rede de entrada de sub-redes publicas"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "public_outbound_acl_rules" {
  description = "ACLs de rede de saída de sub-redes publicas"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "private_inbound_acl_rules" {
  description = "ACLs de rede de entrada de sub-redes internas"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "private_outbound_acl_rules" {
  description = "ACLs de rede de saída de sub-redes internas"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "intra_inbound_acl_rules" {
  description = "ACLs de rede de entrada de sub-redes internas"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "intra_outbound_acl_rules" {
  description = "ACLs de rede de saída de sub-redes internas"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "database_inbound_acl_rules" {
  description = "Database - regras de ACL da rede de entrada de sub-redes"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "database_outbound_acl_rules" {
  description = "Database - Regras de ACL da rede de saída de sub-redes"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "redshift_inbound_acl_rules" {
  description = "Redshift - regras de ACL da rede de entrada de sub-redes"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "redshift_outbound_acl_rules" {
  description = "Redshift - Regras de ACL da rede de saída de sub-redes"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "elasticache_inbound_acl_rules" {
  description = "Elasticache - regras de ACL da rede de entrada de sub-redes"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "elasticache_outbound_acl_rules" {
  description = "Elasticache - Regras de ACL da rede de saída de sub-redes"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

