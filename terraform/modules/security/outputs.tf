output "k8s_sg_id" {
  description = "ID of the Kubernetes security group"
  value       = aws_security_group.k8s_sg.id
}