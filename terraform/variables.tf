variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "ubuntu_ami" {
  description = "Ubuntu AMI ID"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "master_instance_type" {
  description = "Master node instance type"
  type        = string
}

variable "worker_instance_type" {
  description = "Worker node instance type"
  type        = string
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
}

variable "cluster_name" {
  description = "Kubernetes cluster name"
  type        = string
}

variable "dns_domain" {
  description = "Kubernetes DNS domain"
  type        = string
}