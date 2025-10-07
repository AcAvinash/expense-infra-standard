module "vpn_sg" {
  source = "git::https://github.com/AcAvinash/terraform-aws-securitygroup.git"
  project_name = var.project_name
  sg_name = "expense-vpn"
  sg_description = "Allowing all ports from my home IP"
  #sg_ingress_rules = var.sg_ingress_rules
  vpc_id = data.aws_vpc.default.id
  common_tags  = merge(
    var.common_tags,
    {
        Component = "VPN",
        Name = "expense-VPN"
    }
  )
}


# this is the db tier
module "mysql_sg"{
  source = "git::https://github.com/AcAvinash/terraform-aws-securitygroup.git"
  project_name = var.project_name
  sg_name= "mysql_sg"
  sg_description= "Allowing traffic"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = merge(
    var.common_tags,
    {
      Component="Mysql"
      Name="Mysql"
    }
  )
}

# this u can say it is an app tier
module "backend_sg"{
source = "git::https://github.com/AcAvinash/terraform-aws-securitygroup.git"
  project_name = var.project_name
  sg_name= "backend_sg"
  sg_description= "Allowing traffic"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = merge(
    var.common_tags,
    {
      Component="Backend"
      Name="Backend"
    }
  )
}

module "frontend_sg"{
source = "git::https://github.com/AcAvinash/terraform-aws-securitygroup.git"
  project_name = var.project_name
  sg_name= "frontend_sg"
  sg_description= "Allowing traffic"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = merge(
    var.common_tags,
    {
      Component="Frontend"
      Name="Frontend"
    }
  )
}

module "app_alb_sg" {
source = "git::https://github.com/AcAvinash/terraform-aws-securitygroup.git"
  project_name = var.project_name
  sg_name = "App-ALB"
  sg_description = "Allowing traffic"
  #sg_ingress_rules = var.sg_ingress_rules
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = merge(
    var.common_tags,
    {
        Component = "APP",
        Name = "App-ALB"
    }
  )
}


# this is the public load balancer security group
module "frontend_alb_sg" {
source = "git::https://github.com/AcAvinash/terraform-aws-securitygroup.git"
  project_name = var.project_name
  sg_name = "frontend-ALB"
  sg_description = "Allowing traffic"
  #sg_ingress_rules = var.sg_ingress_rules
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = merge(
    var.common_tags,
    {
        Component = "Frontend",
        Name = "Frontend-ALB"
    }
  )
}

resource "aws_security_group_rule" "mysql_backend"{
  type = "ingress"
  description="Allowing port number 3306 from backend"
  from_port= 3306
  to_port=3306
  protocol="tcp"
  source_security_group_id = module.backend_sg.security_group_id
  security_group_id = module.mysql_sg.security_group_id
}

# this is allowing traffic from vpn on port 22 for trouble shooting
resource "aws_security_group_rule" "mysql_vpn"{
  type = "ingress"
  description="Allowing port number 3306 from backend"
  from_port= 22
  to_port=22
  protocol="tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  security_group_id = module.mysql_sg.security_group_id
}

resource "aws_security_group_rule" "backend_vpn"{
  type = "ingress"
  description="Allowing port number 3306 from backend"
  from_port= 22
  to_port=22
  protocol="tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  security_group_id = module.backend_sg.security_group_id
}

resource "aws_security_group_rule" "backend_app_alb"{
  type = "ingress"
  description="Allowing port number 8080 from App alb"
  from_port= 8080
  to_port=8080
  protocol="tcp"
  source_security_group_id = module.app_alb_sg.security_group_id
  security_group_id = module.backend_sg.security_group_id
}
# all load balancer run on port number 80

resource "aws_security_group_rule" "app_alb_vpn"{
  type = "ingress"
  description="Allowing port number 80 from vpn"
  from_port=80
  to_port=80
  protocol="tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  security_group_id = module.app_alb_sg.security_group_id
}

resource "aws_security_group_rule" "app_alb_frontend"{
  type = "ingress"
  description="Allowing port number 80 from frontend"
  from_port=80
  to_port=80
  protocol="tcp"
  source_security_group_id = module.frontend_sg.security_group_id
  security_group_id = module.app_alb_sg.security_group_id
}

resource "aws_security_group_rule" "frontend_vpn"{
  type = "ingress"
  description="Allowing port number 80 from vpn"
  from_port=80
  to_port=80
  protocol="tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  security_group_id = module.frontend_sg.security_group_id
}

resource "aws_security_group_rule" "frontend_frontend_alb"{
  type = "ingress"
  description="Allowing port number 80 from frontend alb"
  from_port=80
  to_port=80
  protocol="tcp"
  source_security_group_id = module.frontend_alb_sg.security_group_id
  security_group_id = module.frontend_sg.security_group_id
}

resource "aws_security_group_rule" "frontend_alb_internet"{
  type = "ingress"
  description="Allowing port number 80 from internet"
  from_port=80
  to_port=80
  protocol="tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.frontend_alb_sg.security_group_id
}