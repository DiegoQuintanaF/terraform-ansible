terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    ansible = {
      version = "~> 1.2.0"
      source  = "ansible/ansible"
    }
  }
}

provider "aws" {
  region                   = var.provider_region
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = var.provider_profile
}
