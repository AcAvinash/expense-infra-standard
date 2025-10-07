variable "project_name" {
  default = "expense"
}

variable "env" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project = "expense"
    Component = "frontend-alb"
    Environment = "DEV"
    Terraform = "true"
  }
}