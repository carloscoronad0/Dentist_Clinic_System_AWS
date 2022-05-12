resource "aws_vpc" "dentist_vpc" {
  cidr_block = "192.168.0.0/16"
  assign_generated_ipv6_cidr_block=true
  enable_dns_hostnames=true
  tags = {
      Name="dentist-vpc"
  }
}

resource "aws_subnet" "dentist_subnets" {
  for_each    = local.subnets
  vpc_id      = local.dentist_vpc_id
  cidr_block  = each.value.cidr_block
  availability_zone = each.value.az

  tags = {
    Name = each.key
    Type = each.value.type
  }
}

resource "aws_internet_gateway" "dentist_vpc_igw"{
  vpc_id = local.dentist_vpc_id 
  
  tags = {
    Name = "dentist-vpc-igw"
  }
}

resource "aws_route_table" "dentist_web_rt" {
  vpc_id = local.dentist_vpc_id 

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dentist_vpc_igw.id
  }

  tags = {
    Name = "dentist-web-rt"
  }
}

resource "aws_route_table_association" "dentist_web_rt_association" {
  for_each = {
    "dentist-web-A" = local.subnets.dentist-web-A
    "dentist-web-B" = local.subnets.dentist-web-B
    "dentist-web-C" = local.subnets.dentist-web-C
  }
  subnet_id      = aws_subnet.dentist_subnets["${each.key}"].id
  route_table_id = aws_route_table.dentist_web_rt.id
}

# Para referenciar: {nombreDelRecurso.nombreNuestro.Atributo}

# Parameter store --------------------------------------------------------------

resource "aws_ssm_parameter" "dentist_ssm_vpc_id" {
  name  = "/dentist_vpc/id"
  type  = "String"
  value = local.dentist_vpc_id
}

resource "aws_ssm_parameter" "dentist_ssm_subnets" {
  for_each = aws_subnet.dentist_subnets
  name  = "/dentist_vpc/subnets/${each.value.tags_all.Type}/${each.value.tags_all.Name}"
  type  = "String"
  value = each.value.id
}