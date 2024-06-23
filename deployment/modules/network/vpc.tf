resource "aws_vpc" "default" {
  cidr_block = local.vpc_cidr
  tags = {
    Name = local.tag_name
  }
}
