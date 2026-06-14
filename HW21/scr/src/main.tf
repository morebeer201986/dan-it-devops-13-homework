provider "aws" {
  region = "eu-central-1"
}

# Creating  SSH key for connect Ansible
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "ansible-ec2-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Private local key for  Ansible
resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/ec2_key.pem"
  file_permission = "0400"
}

# Security Group for access via SSH (22) and HTTP (80)
resource "aws_security_group" "web_sg" {
  name        = "allow_web_ssh"
  description = "Allow SSH and HTTP inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Search for Ubuntu ISO
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Creating two EC2 instance
resource "aws_instance" "web" {
  count                  = 2
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "Web-Server-${count.index + 1}"
  }
}

# Creating Ansible Inventory file
resource "local_file" "ansible_inventory" {
  content = <<-EOT
    [webservers]
    ${aws_instance.web[0].public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=./ec2_key.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no'
    ${aws_instance.web[1].public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=./ec2_key.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no'
  EOT
  filename = "${path.module}/inventory.ini"
}

# Output IP addres in console after create
output "instance_ips" {
  value = aws_instance.web[*].public_ip
}
