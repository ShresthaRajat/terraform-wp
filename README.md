# terraform-wp
Terraform/bash script to configure and launch an Wordpress site in aws.

## Steps
1. Install and aws cli and install terraform
2. Create a key pair for ssh
3. Paste security group and key-pair name at main.tf
4. cd into this repo and run following terraform commands:


```bash
terraform init
terraform plan -var-file=vars/example.tfvars
terraform apply -var-file=vars/example.tfvars
terraform destroy -var-file=vars/example.tfvars
```


This script will create an ubuntu ec2 instance with a basic security group and install wordpress on it