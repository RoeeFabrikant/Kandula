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
  type        = number
}

variable "intance_type" {
  type        = string
  default     = "t2.micro"
}

variable "private_key_name" {
  type        = string
}

variable "server_sg" {
  type        = any
}

variable "script" {
  type        = string
}

variable "iam" {
  type        = string
}