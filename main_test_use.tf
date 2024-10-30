terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "my-terraform-state-bucket"
    key    = "aws-backup/terraform.tfstate"
    region = "us-west-2"
  }
}

provider "aws" {
  region = "us-west-2"
}

module "aws_backup" {
  source = file("./modules/aws_backup")

  # Just one example
  backup_frequency  = "daily"
  backup_retention  = 30
  backup_encryption = "arn:aws:kms:us-west-2:..."  # to update
  owner_email       = "owner@eulerhermes.com"
}

output "backup_plan_id" {
  value = module.aws_backup.backup_plan_id
}

output "backup_vault_name" {
  value = module.aws_backup.backup_vault_name
}