resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "directus-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_security_group" "directus_sg" {
  name = "directus-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8055
    to_port     = 8055
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

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "directus_server" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  key_name = aws_key_pair.generated_key.key_name

  vpc_security_group_ids = [
    aws_security_group.directus_sg.id
  ]

user_data = <<-EOF
#!/bin/bash
apt update -y
apt install -y docker.io docker-compose
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu
EOF


  tags = {
    Name = var.instance_name
  }
}