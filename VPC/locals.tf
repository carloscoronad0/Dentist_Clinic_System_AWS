locals {
  subnets = {
    "dentist-rv-A"= {
      cidr_block="192.168.0.0/20"
      az="us-east-1a"
      type="reserved"
    }
    "dentist-db-A"= {
      cidr_block="192.168.16.0/20"
      az="us-east-1a"
      type="db"
    }
    "dentist-app-A"= {
      cidr_block="192.168.32.0/20"
      az="us-east-1a"
      type="app"
    }
    "dentist-web-A"= {
      cidr_block="192.168.48.0/20"
      az="us-east-1a"
      type="web"
    }
    
    "dentist-rv-B"= {
      cidr_block="192.168.64.0/20"
      az="us-east-1b"
      type="reserved"
    }
    "dentist-db-B"= {
      cidr_block="192.168.80.0/20"
      az="us-east-1b"
      type="db"
    }
    "dentist-app-B"= {
      cidr_block="192.168.96.0/20"
      az="us-east-1b"
      type="app"
    }
    "dentist-web-B"= {
      cidr_block="192.168.112.0/20"
      az="us-east-1b"
      type="web"
    }
    
    "dentist-rv-C"= {
      cidr_block="192.168.128.0/20"
      az="us-east-1c"
      type="reserved"
    }
    "dentist-db-C"= {
      cidr_block="192.168.144.0/20"
      az="us-east-1c"
      type="db"
    }
    "dentist-app-C"= {
      cidr_block="192.168.160.0/20"
      az="us-east-1c"
      type="app"
    }
    "dentist-web-C"= {
      cidr_block="192.168.176.0/20"
      az="us-east-1c"
      type="web"
    }
  }
  
  dentist_vpc_id = aws_vpc.dentist_vpc.id
}