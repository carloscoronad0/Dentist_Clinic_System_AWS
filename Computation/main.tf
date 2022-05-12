# Backend Autoscaling group ----------------------------------------------------

resource "aws_security_group" "dentist_load_balancer_sg" {
  name        = "dentist-load-balancer-sg"
  vpc_id      = data.aws_ssm_parameter.vpc_id_parameter.value

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dentist-load-balancer-sg"
  }
}

resource "aws_security_group" "dentist_instance_sg" {
  name        = "dentist-instance-sg"
  vpc_id      = data.aws_ssm_parameter.vpc_id_parameter.value

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
 
  tags = {
    Name = "dentist-instance-sg"
  }
}

resource "aws_launch_template" "dentist_backend_lt" {
  name = "backend_launch_template"

  image_id = local.instance_ami

  instance_type = "t2.micro"

  key_name = "MyAWSKeyPair"

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [local.instance_sg_id]
  }

  #   vpc_security_group_ids = 

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "dentist-asg-instance"
    }
  }

  user_data = filebase64("${path.module}/user_data.sh")
}

# resource "aws_autoscaling_group" "dentist_backend_asg" {
#   # name = "dentist-backend-autoscaling-group"
#   vpc_zone_identifier = local.subnet_web_ids
#   desired_capacity   = 2
#   max_size           = 3
#   min_size           = 1
  
#   # target_group_arns  = [
#   #   aws_lb_target_group.website_tg.arn
#   # ]

#   launch_template {
#     id      = aws_launch_template.dentist_backend_lt.id
#   }
# }

# resource "aws_lb_target_group" "dentist_backend_lb_tg" {
#   name = "dentist-backend-lb-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = data.aws_ssm_parameter.vpc_id_parameter.value
# }

# resource "aws_lb" "dentist_alb" {
#   name               = "dentist-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.dentist_load_balancer_sg.id]
#   subnets            = local.subnet_web_ids
# }

# resource "aws_autoscaling_attachment" "dentist_asg_attachment" {
#   autoscaling_group_name = aws_autoscaling_group.dentist_backend_asg.id
#   lb_target_group_arn    = aws_lb_target_group.dentist_backend_lb_tg.arn
# }

# resource "aws_lb_listener" "alb_listener" {
#   load_balancer_arn = aws_lb.dentist_alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.dentist_backend_lb_tg.arn
#   }
# }

# Bastion ----------------------------------------------------------------------

resource "aws_instance" "bastion_instance" {
  ami           = local.instance_ami
  associate_public_ip_address = true
  instance_type = "t2.micro"
  key_name = "MyAWSKeyPair"

  #network_interface {
  #  network_interface_id = aws_network_interface.bastion_ni.id
  #  device_index         = 0
  #}
  
  subnet_id = local.bastion_web_subnet
  user_data = <<EOF
#!/bin/bash
yum update -y
sudo yum -y install https://dev.mysql.com/get/mysql80-community-release-el7-5.noarch.rpm
sudo amazon-linux-extras install epel -y
sudo yum -y install mysql-community-server
sudo systemctl enable --now mysqld
sudo yum -y install git
mkdir /dbScripts
git clone ${local.script_repository} /dbScripts
mysql --host=${local.db_host} --user=${local.db_user} --password=${local.db_password} ${local.db_name} < /dbScripts/dentistDBCreation.sql
mysql --host=${local.db_host} --user=${local.db_user} --password=${local.db_password} ${local.db_name} < /dbScripts/dentistDBInsert.sql
mysql --host=${local.db_host} --user=${local.db_user} --password=${local.db_password} ${local.db_name} < /dbScripts/dentistDBViews.sql

#-----------------------------------------------
mkdir /DentistApp
git clone ${local.dentist_app_repository} /DentistApp
touch /DentistApp/node/.env
echo -e "# .env file \n\nDATABASE_NAME=\"${local.db_name}\"\nDATABASE_USER=\"${local.db_user}\"\nDATABASE_PASSWORD=\"${local.db_password}\"\nDATABASE_ADDRESS=\"${local.db_host}\"" > /DentistApp/node/.env

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.0/install.sh | bash
. ~/.nvm/nvm.sh
nvm install 14
(cd /DentistApp/node; npm install; npm run serve)
EOF

  vpc_security_group_ids = [local.instance_sg_id]
}