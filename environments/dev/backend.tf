terraform {
  backend "s3" {
    bucket         = "my-project-terraform-state-dev-123456789012"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
  }
} 