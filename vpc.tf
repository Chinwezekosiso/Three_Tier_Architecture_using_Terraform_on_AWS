resource "aws_vpc" "Three_Tier_Arch_VPC" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  instance_tenancy     = "default"
  
  tags = {
    name = "Three_Tier_Arch_VPC"
  }
}

