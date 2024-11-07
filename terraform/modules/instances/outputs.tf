output "master_private_ip" {
  description = "Private IP of master node"
  value       = aws_instance.master.private_ip
}

output "master_public_ip" {
  description = "Public IP of master node"
  value       = aws_instance.master.public_ip
}

output "master_hostname" {
  description = "Hostname of master node"
  value       = aws_instance.master.private_dns
}

output "worker_private_ips" {
  description = "Private IPs of worker nodes"
  value       = aws_instance.workers[*].private_ip
}

output "worker_public_ips" {
  description = "Public IPs of worker nodes"
  value       = aws_instance.workers[*].public_ip
}

output "worker_hostnames" {
  description = "Hostnames of worker nodes"
  value       = aws_instance.workers[*].private_dns
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}