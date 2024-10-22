terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.31"
    }
  }

  required_version = ">=1.6.6"

  backend "s3" {
    bucket = "1512ninja-tf"
    key    = "1512ninja/allhallowcon"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}
