# Providing inbound and outbound rules for HTTP traffic
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP traffic"

  # Inbound rule to allow HTTP (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rule to allow all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Optional: Add tags if required
  tags = {
    Name = "allow_http"
  }
}

# EC2 instance resource definition
resource "aws_instance" "web" {
  ami           = "ami-05576a079321f21f8"  # Update with the correct AMI ID for your region
  instance_type = "t2.micro"
  key_name      = "webserverjenkinsKP"  # Replace with your own EC2 key pair name

  # Referencing the security group defined above
  security_groups = [aws_security_group.allow_http.name]

  # Optionally, specify a VPC ID and subnet ID if your environment requires it
  # subnet_id = "subnet-xxxxx"  # Uncomment if using a specific subnet

  tags = {
    Name = "Terraform-EC2"
  }

  # User data for EC2 initialization
  user_data = <<-EOF
  #!/bin/bash
  echo "<html><body><h1>My Terraform Web App</h1></body></html>" > /var/www/html/index.html
  sudo systemctl start httpd
  sudo systemctl enable httpd
  EOF
}

# Output EC2 Public IP
output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}

