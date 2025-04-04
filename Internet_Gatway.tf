# Internet Gateway
resource "aws_internet_gateway" "Three_Tier_Arch_Igw" {
   vpc_id = aws_vpc.Three_Tier_Arch_VPC.id


  tags = {
    Name = "Three_Tier_Arch_Igw"
  }
}

# elastic ip address for NAT Gateway
resource "aws_eip" "Three_Tier_Arch_nat_gateway_eip" {
  domain = "vpc"
}

# Nat Gateway
resource "aws_nat_gateway" "Three_Tier_Arch_nat_gateway" {
  allocation_id = aws_eip.Three_Tier_Arch_nat_gateway_eip.id
  subnet_id     = aws_subnet.Three_Tier_Arch_Public_Sub1.id

  tags = {
    Name = "Three_Tier_Arch_nat_gateway"
  }
  depends_on = [aws_internet_gateway.Three_Tier_Arch_Igw]
}

# Route Table
resource "aws_route_table" "Three_Tier_Arch_web_rt" {
  vpc_id = aws_vpc.Three_Tier_Arch_VPC.id
  tags = {
    Name = "Three_Tier_Arch_web_rt"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Three_Tier_Arch_Igw.id
  }
}

resource "aws_route_table" "Three_Tier_Arch_app_rt" {
  vpc_id = aws_vpc.Three_Tier_Arch_VPC.id
  tags = {
    Name = "Three_Tier_Arch_app_rt"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.Three_Tier_Arch_nat_gateway.id
  }
}


# Route Table Association
resource "aws_route_table_association" "Three_Tier_Arch_web_rt1" {
  subnet_id      = aws_subnet.Three_Tier_Arch_Public_Sub1.id
  route_table_id = aws_route_table.Three_Tier_Arch_web_rt.id
}

resource "aws_route_table_association" "Three_Tier_Arch_web_rt2" {
  subnet_id      = aws_subnet.Three_Tier_Arch_Public_Sub2.id
  route_table_id = aws_route_table.Three_Tier_Arch_web_rt.id
}