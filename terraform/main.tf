name: Terraform EC2 Provisioning

on:
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  terraform:
    runs-on: ubuntu-latest

    steps:
      # Step 1: Checkout the repository
      - name: Checkout repository
        uses: actions/checkout@v2

      # Step 2: Set up AWS credentials
      - name: Set up AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: 'us-east-1'  # Set the AWS region directly here

      # Step 3: Install Terraform
      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v1
        with:
          terraform_version: 'latest'  # Install the latest version of Terraform

      # Step 4: Initialize Terraform
      - name: Initialize Terraform
        run: terraform init  # Assuming terraform files are in the root directory

      # Step 5: Run Terraform Plan
      - name: Run Terraform Plan
        run: terraform plan

      # Step 6: Run Terraform Apply
      - name: Run Terraform Apply
        run: terraform apply -auto-approve

      # Step 7: Output EC2 Public IP
      - name: Output EC2 Public IP
        run: |
          PUBLIC_IP=$(terraform output -raw ec2_public_ip)  # Correct output name
          echo "EC2 Public IP: $PUBLIC_IP"

