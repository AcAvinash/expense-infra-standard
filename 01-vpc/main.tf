
module "vpc"{
  source="git::https://github.com/AcAvinash/terraform-aws-vpc-advanced.git"
  env=var.env
  cidr_block = var.cidr_block
  project_name = var.project_name
  common_tags = var.common_tags
  private_subnet_cidr = var.private_subnet_cidr
  public_subnet_cidr = var.public_subnet_cidr
  database_subnet_cidr = var.database_subnet_cidr

 #peering
  is_peering_required = true
  requestor_vpc_id = data.aws_vpc.default.id
  default_route_table_id = data.aws_vpc.default.main_route_table_id
  default_vpc_cidr = data.aws_vpc.default.cidr_block

}