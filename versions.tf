terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.54"
    }
  }
  required_version = ">= 0.13.7"
}
