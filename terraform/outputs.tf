# terraform/outputs.tf
#edit
output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}
