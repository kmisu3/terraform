# VPCモジュールの使用例
module "vpc" {
  source = "../../modules/vpc"

  name_prefix = local.project_prefix
  vpc_cidr    = var.vpc_cidr
  
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  
  create_internet_gateway = var.create_internet_gateway
  create_nat_gateway      = var.create_nat_gateway

  tags = local.tags
}

# 追加のリソースはここに定義してください
# 例: EC2インスタンス、RDS、ALB等

# 他のモジュールの呼び出し例（コメントアウト）
# module "rds" {
#   source = "../../modules/rds"
#   
#   name_prefix         = local.project_prefix
#   environment         = local.environment
#   vpc_id              = module.vpc.vpc_id
#   private_subnet_ids  = module.vpc.private_subnet_ids
#   tags                = local.tags
# }
# 
# module "alb" {
#   source = "../../modules/alb"
#   
#   name_prefix        = local.project_prefix
#   environment        = local.environment
#   vpc_id             = module.vpc.vpc_id
#   public_subnet_ids  = module.vpc.public_subnet_ids
#   tags               = local.tags
# } 