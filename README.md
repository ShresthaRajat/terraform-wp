# terraform-wp
Terraform/bash script to configure and launch an Wordpress site in aws.

## Steps
1. Configure aws cli
2. Install terraform
3. Create a security group
4. Create a key pair for ssh
5. Paste security group and key-pair name at main.tf
run following terraform commands to initialize, view and deploy:
```bash
terraform init
terraform plan
terraform apply
```


This script will create an ubuntu ec2 instance and install wordpress on it