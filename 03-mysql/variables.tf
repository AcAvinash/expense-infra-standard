variable "project_name" {
  default = "expense"
}

variable "env" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project = "mysql"
    Component = "mysql"
    Environment = "DEV"
    Terraform = "true"
  }
}

variable "zone_name" {
  default = "joindevops.fun"
}