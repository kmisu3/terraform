terraform {
  backend "s3" {
    bucket         = "my-project-terraform-state-prod-123456789012" # settingsで作成したバケット名に更新する
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
  }
} 