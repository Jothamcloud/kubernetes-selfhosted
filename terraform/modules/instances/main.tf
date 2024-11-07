resource "aws_instance" "master" {
  ami          = var.ubuntu_ami
  instance_type = var.master_instance_type
  subnet_id     = var.private_subnet_ids[0]

  vpc_security_group_ids = [var.security_group_id]
  key_name              = var.key_name

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }

  tags = {
    Name        = "${var.environment}-k8s-master"
    Environment = var.environment
    Role        = "master"
  }
}

resource "aws_instance" "workers" {
  count         = var.worker_count
  ami           = var.ubuntu_ami
  instance_type = var.worker_instance_type
  subnet_id     = var.private_subnet_ids[count.index % length(var.private_subnet_ids)]

  vpc_security_group_ids = [var.security_group_id]
  key_name              = var.key_name

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }

  tags = {
    Name        = "${var.environment}-k8s-worker-${count.index + 1}"
    Environment = var.environment
    Role        = "worker"
  }
}

resource "aws_instance" "bastion" {
  ami           = var.ubuntu_ami
  instance_type = "t2.micro"
  subnet_id     = var.public_subnet_ids[0]
  key_name      = var.key_name
  
  vpc_security_group_ids = [var.security_group_id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.environment}-bastion"
  }
}

