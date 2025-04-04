  # Public Subnet1
  resource "aws_subnet" "Three_Tier_Arch_Public_Sub1" {
  vpc_id                  = aws_vpc.Three_Tier_Arch_VPC.id
  cidr_block              = "10.0.0.0/28"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-2a"

  tags = {
    Name = "Three_Tier_Arch_Public_Sub1"
  }
}

  # Public Subnet2
  resource "aws_subnet" "Three_Tier_Arch_Public_Sub2" {
  vpc_id                  = aws_vpc.Three_Tier_Arch_VPC.id
  cidr_block              = "10.0.0.16/28"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-2b"

  tags = {
    Name = "Three_Tier_Arch_Public_Sub2"
  }
}

  # Private Subnet
  resource "aws_subnet" "Three_Tier_Arch_Private_Sub" {
  vpc_id                  = aws_vpc.Three_Tier_Arch_VPC.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-2a"

  tags = {
    Name = "Three_Tier_Arch_Private_Sub"
  }
}