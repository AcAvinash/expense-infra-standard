resource "aws_ssm_parameter" "vpn_sg_id" {
  name  = "/${var.project_name}/${var.env}/vpn_sg_id"
  type  = "String"
  value = module.vpn_sg.security_group_id # module should have output declaration
}

resource "aws_ssm_parameter" "mysql_sg_id" {
  name  = "/${var.project_name}/${var.env}/mysql_sg_id"
  type  = "String"
  value = module.mysql_sg.security_group_id # module should have output declaration
}

resource "aws_ssm_parameter" "backend_sg_id" {
  name  = "/${var.project_name}/${var.env}/backend_sg_id"
  type  = "String"
  value = module.backend_sg.security_group_id # module should have output declaration
}


resource "aws_ssm_parameter" "fronetnd_sg_id" {
  name  = "/${var.project_name}/${var.env}/frontend_sg_id"
  type  = "String"
  value = module.frontend_sg.security_group_id # module should have output declaration
}

resource "aws_ssm_parameter" "app_alb_sg_id" {
  name  = "/${var.project_name}/${var.env}/app_alb_sg_id"
  type  = "String"
  value = module.app_alb_sg.security_group_id # module should have output declaration
}

resource "aws_ssm_parameter" "frontend_alb_sg_id" {
  name  = "/${var.project_name}/${var.env}/frontend_alb_sg_id"
  type  = "String"
  value = module.web_alb_sg.security_group_id # module should have output declaration
}