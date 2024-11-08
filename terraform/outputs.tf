output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = module.vpc.public_subnet_ids
}

output "master_public_ip" {
  description = "Public IP of master node"
  value       = module.instances.master_public_ip
}

output "worker_public_ips" {
  description = "Public IPs of worker nodes"
  value       = module.instances.worker_public_ips
}