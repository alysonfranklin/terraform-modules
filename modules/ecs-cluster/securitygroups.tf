resource "aws_security_group" "cluster" {
  name        = "${var.CLUSTER_NAME}-ecs-${var.DEFAULT_TAGS["Environment"]}"
  vpc_id      = var.VPC_ID
  description = "${var.CLUSTER_NAME}-ecs-${var.DEFAULT_TAGS["Environment"]}"
  tags        = var.DEFAULT_TAGS
}

resource "aws_security_group_rule" "cluster-allow-ssh" {
  count                    = var.ENABLE_SSH ? 1 : 0
  security_group_id        = aws_security_group.cluster.id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = var.SSH_SG
}

/*
resource "aws_security_group_rule" "vpc_endpoint" {
  security_group_id        = aws_security_group.cluster.id
  description              = "VPC Endpoint"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.cluster.id
}
*/

resource "aws_security_group_rule" "cluster-egress" {
  security_group_id = aws_security_group.cluster.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "cluster-ecs" {
  security_group_id = aws_security_group.cluster.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = aws_security_group.cluster.id
  description = "${var.CLUSTER_NAME}-ecs"
}

resource "aws_security_group_rule" "vpn" {
  security_group_id = aws_security_group.cluster.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  //cidr_blocks       = [var.VPN_IP]
  description = "VPN"
  cidr_blocks =  [var.VPN_IP != "" ? var.VPN_IP : "0.0.0.0/0"] // Se var.VPN_IP for uma string vazia, o resultado é "0.0.0.0/0", mas caso contrário, é o valor real de var.VPN_IP
}
