# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-vpc"
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  count  = var.create_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-igw"
    }
  )
}

# Public Subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-public-subnet-${count.index + 1}"
      Type = "Public"
    }
  )
}

# Private Subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-private-subnet-${count.index + 1}"
      Type = "Private"
    }
  )
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
  count  = var.create_internet_gateway && length(var.public_subnet_cidrs) > 0 ? 1 : 0
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main[0].id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-public-rt"
    }
  )
}

# Route Table Association for Public Subnets
resource "aws_route_table_association" "public" {
  count = var.create_internet_gateway && length(var.public_subnet_cidrs) > 0 ? length(aws_subnet.public) : 0

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

# NAT Gateway EIP
resource "aws_eip" "nat" {
  count = var.create_nat_gateway ? length(var.public_subnet_cidrs) > 0 ? 1 : 0 : 0

  domain = "vpc"
  depends_on = [aws_internet_gateway.main]

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-nat-eip"
    }
  )
}

# NAT Gateway
resource "aws_nat_gateway" "main" {
  count = var.create_nat_gateway && length(var.public_subnet_cidrs) > 0 ? 1 : 0

  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-nat-gw"
    }
  )

  depends_on = [aws_internet_gateway.main]
}

# Route Table for Private Subnets
resource "aws_route_table" "private" {
  count = var.create_nat_gateway && length(var.private_subnet_cidrs) > 0 ? 1 : 0

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[0].id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-private-rt"
    }
  )
}

# Route Table Association for Private Subnets
resource "aws_route_table_association" "private" {
  count = var.create_nat_gateway && length(var.private_subnet_cidrs) > 0 ? length(aws_subnet.private) : 0

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[0].id
}

# Data source for availability zones
data "aws_availability_zones" "available" {
  state = "available"
} 