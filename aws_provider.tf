terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

  backend "s3" {
    bucket         = "bkss-tf"
    dynamodb_table = "bkss-tf-dynamod-block"
    key            = "terraform.state"
    region         = "eu-west-2"
  }
}

provider "aws" {
  region                   = "eu-west-2"
  profile                  = "default"
  shared_credentials_files = ["~/.aws/credentials"]
}

provider "http" {
}

