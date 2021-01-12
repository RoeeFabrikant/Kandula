# ALB VARIABLES

variable "project_name" {
  description = "the project name"
  type        = string
}

variable "security_groups" {
    type      = any
}

variable "subnets" {
    type      = any
}

variable "vpc" {
    type      = string
}

variable "instances_id_jenkins" {
    type      = any
}

variable "instances_id_consul" {
    type      = any
}
