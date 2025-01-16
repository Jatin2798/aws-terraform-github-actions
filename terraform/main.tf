resource "aws_instance" "web" {
  ami           = "ami-05576a079321f21f8"  # Update with the correct AMI ID for your region
  instance_type = "t2.micro"
  key_name      = "webserverjenkinsKP"  # Make sure this matches your actual key pair name

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
