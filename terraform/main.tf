# terraform/main.tf

# Providing inbound and outbound rules
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP traffic"
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

# EC2 instance resource definition
resource "aws_instance" "web" {
  ami           = "ami-07b69f62c1d38b012"  # Update with the correct AMI ID for your region
  instance_type = "t2.micro"
  key_name      = "Jatinkeypair"  # Replace with your own EC2 key pair name

  security_groups = [aws_security_group.allow_http.name]

  tags = {
    Name = "Terraform-EC2"
  }

  user_data = <<-EOF
  #!/bin/bash
  echo "<html><body><h1>My Terraform Web App</h1></body></html>" > /var/www/html/index.html
  sudo systemctl start httpd
  sudo systemctl enable httpd
  EOF
}  # <-- Missing closing brace here
