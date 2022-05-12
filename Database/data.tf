data "aws_ssm_parameters_by_path" "dentist_vpc_db_subnets" {
  path = "/dentist_vpc/subnets/db"
}

data "aws_ssm_parameter" "vpc_id_parameter" {
  name = "/dentist_vpc/id"
}