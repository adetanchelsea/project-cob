resource "aws_vpc" "cob_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = "${var.standard_name}-vpc"
  })
}

resource "aws_internet_gateway" "cob_int_gateway" {
  vpc_id = aws_vpc.cob_vpc.id

  tags = merge(var.tags, {
    Name = "${var.standard_name}-igw"
  })
}

locals {
  az_count = length(var.azs)

  public_cidrs = [
    for i in range(local.az_count):
    cidrsubnet(var.vpc_cidr, 8, i)
  ]

  private_cidrs = [
    for i in range(local.az_count):
    cidrsubnet(var.vpc_cidr, 8, i + 10)
  ]

  database_cidrs = [
    for i in range(local.az_count):
    cidrsubnet(var.vpc_cidr, 8, i + 20)
  ]
  nat_az_list = var.nat_gateway_strategy == "one_per_az" ? var.azs : [var.azs[0]]
}

resource "aws_subnet" "public" {
  for_each = { for idx, az in var.azs : az => idx }

  vpc_id                  = aws_vpc.cob_vpc.id
  availability_zone       = each.key
  cidr_block              = local.public_cidrs[each.value]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.standard_name}-public-${each.key}"
  })
}

resource "aws_subnet" "private" {
  for_each = { for idx, az in var.azs : az => idx }

  vpc_id            = aws_vpc.cob_vpc.id
  availability_zone = each.key
  cidr_block        = local.private_cidrs[each.value]

  tags = merge(var.tags, {
    Name = "${var.standard_name}-private-${each.key}"
  })
}

resource "aws_subnet" "database" {
  for_each = { for idx, az in var.azs : az => idx }

  vpc_id            = aws_vpc.cob_vpc.id
  availability_zone = each.key
  cidr_block        = local.database_cidrs[each.value]

  tags = merge(var.tags, {
    Name = "${var.standard_name}-database-${each.key}"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.cob_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cob_int_gateway.id
  }

  tags = merge(var.tags, {
    Name = "${var.standard_name}-public-rt"
  })
}

resource "aws_eip" "nat" {
  for_each = toset(local.nat_az_list)
  domain = "vpc"
  tags = merge(var.tags, {
    Name = "${var.standard_name}-nat-eip-${each.key}"
  })
}

resource "aws_nat_gateway" "cob_nat_gateway" {
  for_each = aws_eip.nat

  allocation_id = each.value.id
  subnet_id     = aws_subnet.public[each.key].id

  tags = merge(var.tags, {
    Name = "${var.standard_name}-nat-${each.key}"
  })

  depends_on = [aws_internet_gateway.cob_int_gateway]
}

resource "aws_route_table" "private" {
  for_each = aws_subnet.private

  vpc_id = aws_vpc.cob_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_strategy == "one_per_az" ? aws_nat_gateway.cob_nat_gateway[each.key].id : aws_nat_gateway.cob_nat_gateway[var.azs[0]].id
  }

  tags = merge(var.tags, {
    Name = "${var.standard_name}-private-rt-${each.key}"
  })
}

resource "aws_route_table" "database" {
  for_each = aws_subnet.database

  vpc_id = aws_vpc.cob_vpc.id

  tags = merge(var.tags, {
    Name = "${var.standard_name}-database-rt-${each.key}"
  })
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_route_table_association" "database" {
  for_each = aws_subnet.database

  subnet_id      = each.value.id
  route_table_id = aws_route_table.database[each.key].id
}