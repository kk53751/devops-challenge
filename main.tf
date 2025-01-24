

resource "aws_instance" "app_server" {
  ami           = "ami-0040d891e3c1949fc" # Replace with a valid AMI ID for your region
  instance_type = var.instance_type

  tags = {
    Name = "ExampleAppServerInstance"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "Welcome to the DevOps Challenge" > /var/www/html/index.html
              EOF

  lifecycle {
    create_before_destroy = true
  }
}
