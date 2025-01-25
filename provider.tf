terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.9.0"

  backend "s3" {
    bucket         = "lon-terraform-bucket" # Replace with your desired bucket name
    key            = "terraform/state"
    region         = "eu-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
    region = "eu-west-2" # Change to your desired region
#    access_key = var.AWS_ACCESS_KEY_ID	
#    secret_key = var.AWS_SECRET_ACCESS_KEY	

 }


