locals {
    # instance
    instance_ami = "ami-0022f774911c1d690"
    instance_sg_id = aws_security_group.dentist_instance_sg.id
    
    # subnets
    subnet_web_ids = data.aws_ssm_parameters_by_path.dentist_vpc_web_subnets.values
    bastion_web_subnet = data.aws_ssm_parameter.dentist_vpc_bastion_web_subnet.value
    
    # Database
    db_name = data.aws_ssm_parameter.dentist_db_name.value
    db_user = data.aws_ssm_parameter.dentist_db_u.value
    db_password = data.aws_ssm_parameter.dentist_db_pass.value
    db_host = data.aws_ssm_parameter.dentist_db_addr.value
    
    # Repos
    script_repository = "https://github.com/carloscoronad0/aws-project-random-files.git"
    dentist_app_repository = "https://github.com/carloscoronad0/Dentist_Clinic_System.git"
}