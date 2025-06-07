provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  
  backend "s3" {
    bucket = "terraform-state-stg"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
    encrypt = true
  }
}

# ここにリソース定義を追加 