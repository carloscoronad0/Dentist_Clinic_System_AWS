# VPC --------------------------------------------------------------------------

data "aws_ssm_parameter" "vpc_id_parameter" {
  name = "/dentist_vpc/id"
}

data "aws_ssm_parameters_by_path" "dentist_vpc_web_subnets" {
  path = "/dentist_vpc/subnets/web"
}

data "aws_ssm_parameter" "dentist_vpc_bastion_web_subnet" {
  name = "/dentist_vpc/subnets/web/dentist-web-B"
}

# Database ---------------------------------------------------------------------

data "aws_ssm_parameter" "dentist_db_name" {
  name = "/dentist_db/dbName"
}

data "aws_ssm_parameter" "dentist_db_addr" {
  name = "/dentist_db/address"
}

data "aws_ssm_parameter" "dentist_db_u" {
  name = "/dentist_db/username"
}

data "aws_ssm_parameter" "dentist_db_pass" {
  name = "/dentist_db/password"
}