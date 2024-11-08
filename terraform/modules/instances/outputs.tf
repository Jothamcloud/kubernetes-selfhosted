output "master_public_ip" {
  description = "Public IP of master node"
  value       = aws_instance.master.public_ip
}

output "master_hostname" {
  description = "Hostname of master node"
  value       = aws_instance.master.private_dns
}

output "worker_public_ips" {
  description = "Public IPs of worker nodes"
  value       = aws_instance.workers[*].public_ip
}

output "worker_hostnames" {
  description = "Hostnames of worker nodes"
  value       = aws_instance.workers[*].private_dns
}

output "worker_instance_ids" {
  description = "List of worker instance IDs"
  value       = aws_instance.workers[*].id
}