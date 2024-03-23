provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAXYKJW5IITFHPQSHI"
  secret_key = "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"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
terraform {
  backend "s3" {
    bucket         = "arjun-bucket12"                        #buceket name
    key            = "terraform/remote/s3/terraform.tfstate" #path where we are going to st ore the state file
    region         = "us-east-1"
    dynamodb_table = "dynamodb-state-locking" #dynamodb table creation
  }
}