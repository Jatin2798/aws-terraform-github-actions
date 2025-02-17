# Providing inbound and outbound rules for HTTP traffic
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

  tags = {
    Name = "allow_http"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-05576a079321f21f8"
  instance_type = "t2.micro"
  key_name      = "webserverjenkinsKP"

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
}

output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}

