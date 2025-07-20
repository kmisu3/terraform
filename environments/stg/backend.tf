terraform {
  backend "s3" {
    bucket         = "my-project-terraform-state-stg-123456789012" # settingで作成したバケット名に更新する
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
  }
} 