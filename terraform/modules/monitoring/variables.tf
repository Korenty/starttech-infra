variable "project_name" {
  type        = string
  description = "The target deployment identifier name string"
}

variable "environment" {
  type        = string
  description = "The environment classification lifecycle stage"
}

variable "data_subnet_ids" {
  type        = list(string)
  description = "Isolated data subnet IDs where the Redis cluster resides securely"
}

variable "redis_sg_id" {
  type        = string
  description = "The tracking security group firewall boundary identifier for data layers"
}
