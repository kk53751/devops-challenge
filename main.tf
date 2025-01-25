

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "tf-key-pair"
  public_key = tls_private_key.ssh_key.public_key_openssh
}



resource "aws_instance" "web_server" {
  ami                    = "ami-0040d891e3c1949fc" # Replace with a valid AMI ID for your region
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ec2_key_pair.key_name
  security_groups        = [aws_security_group.web_sg.name]
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  tags = {
    Name = "WebServer"
  }

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y python3
  EOF
}

resource "null_resource" "setup_vm" {
  triggers = {
    instance_id = aws_instance.web_server.id
    public_ip   = aws_instance.web_server.public_ip
    private_key = tls_private_key.ssh_key.private_key_pem
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "${tls_private_key.ssh_key.private_key_pem}" >> /tmp/private.pem
      echo "${aws_instance.web_server.public_ip}" >> inventory.txt
      chmod 600 /tmp/private.pem
      sleep 60; ansible-playbook  -v -u ubuntu  setup_vm.yml -i inventory.txt --private-key /tmp/private.pem
    EOT
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }
}



resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Security group for web access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTPS from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}



