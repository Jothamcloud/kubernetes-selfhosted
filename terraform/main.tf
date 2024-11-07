provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  environment          = var.environment
}

module "security" {
  source      = "./modules/security"
  vpc_id      = module.vpc.vpc_id
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
}

module "instances" {
  source               = "./modules/instances"
  vpc_id               = module.vpc.vpc_id
  ubuntu_ami           = var.ubuntu_ami
  private_subnet_ids   = module.vpc.private_subnet_ids
  public_subnet_ids    = module.vpc.public_subnet_ids 
  security_group_id    = module.security.k8s_sg_id
  key_name             = var.key_name
  master_instance_type = var.master_instance_type
  worker_instance_type = var.worker_instance_type
  worker_count         = var.worker_count
  environment          = var.environment
}

# Generate Ansible inventory
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tmpl",
    {
      bastion_public_ip = module.instances.bastion_public_ip
      master_private_ip = module.instances.master_private_ip
      master_hostname   = module.instances.master_hostname
      worker_ips        = module.instances.worker_private_ips
    }
  )
  filename = "../ansible/inventory.ini"
}

resource "local_file" "ansible_vars" {
  content = templatefile("${path.module}/templates/ansible_vars.tmpl",
    {
      kubernetes_version = var.kubernetes_version
    }
  )
  filename = "../ansible/group_vars/all.yml"
}

# Run Ansible playbook
resource "null_resource" "ansible_provisioner" {
  depends_on = [
    local_file.ansible_inventory,
    local_file.ansible_vars,
    module.instances,
    module.vpc
  ]

  provisioner "local-exec" {
    command = <<-EOT
      sleep 250 # Wait for instances to be ready
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
        -i ../ansible/inventory.ini \
        ../ansible/site.yml
    EOT
  }
}