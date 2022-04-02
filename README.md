# Store-Terraform-state-file-on-S3
## This repo is to store the state file of terraform on a remote S3 bucket on AWS

- First create the bucket 
- second assign the state to it, migrate the previous state to s3

## Command to run
- terraform init
- terraform apply -var-file="terraform.tfvars"
