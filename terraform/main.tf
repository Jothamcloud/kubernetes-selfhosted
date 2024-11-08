provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  availability_zones   = var.availability_zones
  environment          = var.environment
}

module "security" {
  source              = "./modules/security"
  vpc_id              = module.vpc.vpc_id
  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
}

module "instances" {
  source               = "./modules/instances"
  vpc_id               = module.vpc.vpc_id
  ubuntu_ami           = var.ubuntu_ami
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
      master_public_ip  = module.instances.master_public_ip
      master_hostname   = module.instances.master_hostname
      worker_public_ips = module.instances.worker_public_ips
    }
  )
  filename = "../ansible/inventory.ini"
}
# Run Ansible playbook
resource "null_resource" "ansible_provisioner" {
  depends_on = [
    local_file.ansible_inventory,
    module.instances,
    module.vpc
  ]

  provisioner "local-exec" {
    command = <<-EOT
      sleep 70 # Reduced wait time since we're using public IPs
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
        -i ../ansible/inventory.ini \
        ../ansible/site.yml
    EOT
  }
}