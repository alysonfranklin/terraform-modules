output "cluster_arn" {
  value = aws_ecs_cluster.cluster.id
}

output "service_role_arn" {
  value = aws_iam_role.cluster-service-role.arn
}

output "cluster_sg" {
  value = aws_security_group.cluster.id
}

output "role_policy" {
  value = aws_iam_role_policy.cluster-ec2-role.id
}
