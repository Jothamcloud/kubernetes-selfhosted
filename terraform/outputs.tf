output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "master_private_ip" {
  description = "Private IP of the master node"
  value       = module.instances.master_private_ip
}

output "master_public_ip" {
  description = "Public IP of the master node"
  value       = module.instances.master_public_ip
}

output "worker_private_ips" {
  description = "Private IPs of worker nodes"
  value       = module.instances.worker_private_ips
}

output "worker_public_ips" {
  description = "Public IPs of worker nodes"
  value       = module.instances.worker_public_ips
}

output "kubernetes_security_group_id" {
  description = "ID of the Kubernetes security group"
  value       = module.security.k8s_sg_id
}
