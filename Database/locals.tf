locals {
    db_username = "root"
    db_password = "dentist_db"
    db_name = "mydentistdatabase"
    
    dentist_vpc_id = data.aws_ssm_parameter.vpc_id_parameter.value
    dentist_vpc_db_subnets = data.aws_ssm_parameters_by_path.dentist_vpc_db_subnets.values
}