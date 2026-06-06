variable "project_name" {
  type        = string
  description = "The reference naming convention string"
}

variable "environment" {
  type        = string
  description = "The target runtime environment classification"
}

variable "instance_type" {
  type        = string
  description = "The computing size parameters for execution nodes"
}

variable "vpc_id" {
  type        = string
  description = "The tracking network identifier link"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs used for the ALB ingress layer"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs where backend nodes scale securely"
}

variable "alb_sg_id" {
  type        = string
  description = "The load balancer configuration security barrier identifier"
}

variable "backend_sg_id" {
  type        = string
  description = "The EC2 backend layer configuration security barrier identifier"
}

variable "aws_account_id" {
  type        = string
  description = "The 12-digit AWS Account ID"
  default     = "475418221916"
}