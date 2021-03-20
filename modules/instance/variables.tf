# instance VARIABLES

variable "project_name" {
  description = "the project name"
  type        = string
}

variable "server_name" {
    type      = string
}

variable "sub_id" {
  type        = list(string)
}

variable "num_of_instances" {
  type        = string
}

variable "intance_type" {
  type        = string
  default     = "t2.micro"
}

variable "private_key_name" {
  type        = string
}

variable "server_sg" {
  type        = list(string)
}

variable "script" {
  type        = string
}

variable "iam" {
  type        = string
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "route53_zone_id" {
  type        = string
}

variable "dns_name" {
  type        = string
}