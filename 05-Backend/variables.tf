variable "project_name" {
  default = "expense"
}

variable "env" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project = "expense"
    Component = "backend"
    Environment = "DEV"
    Terraform = "true"
  }
}