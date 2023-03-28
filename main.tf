terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
      bucket = "websitetask1"
      key    = "main.tfstate"
      region = "us-west-2"
  }
}

#Configure the aws provider
provider "aws" {
  region = var.region
  profile = "default"
}
