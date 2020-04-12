resource "aws_vpc" "this" {
  cidr_block                       = var.vpc_cidr
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  assign_generated_ipv6_cidr_block = var.enable_ipv6

  tags = merge(
    {
      "Name" = "${var.environment_name}-VPC"
    },
    var.tags,
  )
}

resource "aws_internet_gateway" "this" {
  count = var.create_igw ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      "Name" = "${var.environment_name}-IGW"
    },
    var.tags,
  )
}

data "aws_availability_zones" "this" {
  state = "available"
}

locals {
  azs = data.aws_availability_zones.this.names
  nat_gateway_count = (var.enable_nat_gateway
  ? (var.single_nat_gateway ? 1 : length(var.private_subnets)) : 0)
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id     = aws_vpc.this.id
  cidr_block = var.private_subnets[count.index]

  assign_ipv6_address_on_creation = (var.enable_ipv6
  ? var.private_assign_ipv6_address_on_creation : false)
  ipv6_cidr_block = (var.enable_ipv6 && length(var.private_subnet_ipv6_cidrs) > 0
  ? var.private_subnet_ipv6_cidrs[count.index] : null)

  // ensure index is with the length of azs
  availability_zone = element(local.azs, count.index)

  tags = merge(
    {
      "Name" = "${var.environment_name}-PrivateSubnet-${count.index}"
    },
    var.tags,
  )
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  assign_ipv6_address_on_creation = (var.enable_ipv6
  ? var.public_assign_ipv6_address_on_creation : false)
  ipv6_cidr_block = (var.enable_ipv6 && length(var.public_subnet_ipv6_cidrs) > 0
  ? var.public_subnet_ipv6_cidrs[count.index] : null)

  // ensure index is with the lenght of azs
  availability_zone = element(local.azs, count.index)

  tags = merge(
    {
      "Name" = "${var.environment_name}-PublicSubnet-${count.index}"
    },
    var.tags,
  )
}

resource "aws_eip" "this" {
  vpc  = true
  tags = var.tags

  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  count = local.nat_gateway_count

  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.private.*.id

  tags = merge(
    {
      "Name" = "${var.environment_name}-NATGateway-${count.index}"
    },
    var.tags,
  )
}

resource "aws_route_table" "public" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      "Name" = "${var.environment_name}-RouteTable-${count.index}"
    },
    var.tags,
  )
}

resource "aws_route_table" "private" {
  count = local.nat_gateway_count

  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      "Name" = "${var.environment_name}-RouteTable-${count.index}"
    },
    var.tags,
  )
}

resource "aws_route" "private" {
  count = local.nat_gateway_count

  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this.*.id, count.index)

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
}

resource "aws_route_table_association" "private" {
  count = local.nat_gateway_count

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
