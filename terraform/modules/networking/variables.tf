variable "project_name" {
  type        = string
  description = "The root infrastructure deployment reference string"
}

variable "environment" {
  type        = string
  description = "The environment classification boundary identifier"
}

variable "vpc_cidr" {
  type        = string
  description = "The primary IP routing network definition block"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "The explicit public routing configurations array"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "The explicit compute routing configurations array"
}

variable "data_subnet_cidrs" {
  type        = list(string)
  description = "The explicit caching routing configurations array"
}
