resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}-public"
    Environment = var.environment
    Owner = "Khechini Mohamed"
  }
}

resource "aws_route" "public_routes" {
  route_table_id  = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"

  gateway_id = aws_internet_gateway.gateway.id
}

resource "aws_route_table_association" "public_route_association" {
    for_each =  var.availability_zones

    subnet_id      = aws_subnet.public[each.key].id
    route_table_id = aws_route_table.public_route_table.id
}


resource "aws_route_table" "private_route_table" {
  for_each = var.availability_zones
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}-private-${var.aws_region}${each.key}"
    Environment = var.environment
    Owner = "Khechini Mohamed"
  }
}


resource "aws_route" "private_routes" {
    for_each = var.availability_zones

    route_table_id  = aws_route_table.private_route_table[each.key].id
    destination_cidr_block = "0.0.0.0/0"
    network_interface_id = aws_instance.private_instance[each.key].primary_network_interface_id
}


resource "aws_route_table_association" "private_route_association" {
    for_each =  var.availability_zones

    subnet_id      = aws_subnet.private[each.key].id
    route_table_id = aws_route_table.private_route_table[each.key].id
}