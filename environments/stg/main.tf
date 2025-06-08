# S3バケットとDynamoDBは、bootstrapディレクトリで作成済み

# 他のモジュールの呼び出し例
# module "api_gateway" {
#   source = "../../modules/api-gateway"
#   
#   # モジュールに渡すパラメータ
#   name        = "${local.project_prefix}-api-${local.environment}"
#   environment = local.environment
#   tags        = local.tags
# }
# 
# module "waf" {
#   source = "../../modules/waf"
#   
#   name        = "${local.project_prefix}-waf-${local.environment}"
#   environment = local.environment
#   tags        = local.tags
# }
# 
# module "alb" {
#   source = "../../modules/alb"
#   
#   name        = "${local.project_prefix}-alb-${local.environment}"
#   environment = local.environment
#   tags        = local.tags
# } 