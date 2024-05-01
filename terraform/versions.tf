terraform {
  required_version = ">= 1.6"

  backend "s3" {
    bucket         = "brainscale-app-bucket"
    key            = "state/path/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
