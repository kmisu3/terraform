output "vpc_id" {
  description = "VPCのID"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "VPCのCIDRブロック"
  value       = aws_vpc.main.cidr_block
}

output "internet_gateway_id" {
  description = "Internet GatewayのID"
  value       = var.create_internet_gateway ? aws_internet_gateway.main[0].id : null
}

output "public_subnet_ids" {
  description = "パブリックサブネットのIDリスト"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "プライベートサブネットのIDリスト"
  value       = aws_subnet.private[*].id
}

output "public_subnet_cidrs" {
  description = "パブリックサブネットのCIDRブロックリスト"
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_cidrs" {
  description = "プライベートサブネットのCIDRブロックリスト"
  value       = aws_subnet.private[*].cidr_block
}

output "nat_gateway_id" {
  description = "NAT GatewayのID"
  value       = var.create_nat_gateway && length(var.public_subnet_cidrs) > 0 ? aws_nat_gateway.main[0].id : null
}

output "nat_gateway_ip" {
  description = "NAT GatewayのパブリックIP"
  value       = var.create_nat_gateway && length(var.public_subnet_cidrs) > 0 ? aws_eip.nat[0].public_ip : null
}

output "public_route_table_id" {
  description = "パブリックルートテーブルのID"
  value       = var.create_internet_gateway && length(var.public_subnet_cidrs) > 0 ? aws_route_table.public[0].id : null
}

output "private_route_table_id" {
  description = "プライベートルートテーブルのID"
  value       = var.create_nat_gateway && length(var.private_subnet_cidrs) > 0 ? aws_route_table.private[0].id : null
} 