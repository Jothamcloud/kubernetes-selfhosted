variable "aws_region" {
  description = "AWS region to deploy the infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (e.g., production, staging)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "master_instance_type" {
  description = "Instance type for the master node"
  type        = string
  default     = "t2.medium"
}

variable "worker_instance_type" {
  description = "Instance type for worker nodes"
  type        = string
  default     = "t2.medium"
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

variable "kubernetes_version" {
  description = "Kubernetes version to install"
  type        = string
}

variable "pod_network_cidr" {
  description = "CIDR block for pod network"
  type        = string
  default     = "192.168.0.0/16"
}

variable "service_cidr" {
  description = "CIDR block for Kubernetes services"
  type        = string
  default     = "10.96.0.0/12"
}

variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}

variable "dns_domain" {
  description = "DNS domain for the cluster"
  type        = string
  default     = "cluster.local"
}

variable "container_runtime" {
  description = "Container runtime to use"
  type        = string
  default     = "containerd"
}

variable "ubuntu_ami" {
  description = "AMI ID for Ubuntu instances"
  type        = string
}

variable "worker_labels" {
  description = "Labels to apply to Kubernetes worker nodes"
  type        = map(string)
  default     = {
    "node.kubernetes.io/type" = "worker"
    environment = "production"
  }
}