variable "aws_region" {
  type        = string
  description = "The target AWS region for deployment"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "The target deployment lifecycle stage"
  default     = "production"
}

variable "project_name" {
  type        = string
  description = "The base project name string for resource tagging"
  default     = "starttech"
}

variable "vpc_cidr" {
  type        = string
  description = "The base Classless Inter-Domain Routing block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR tracking arrays for the ingress public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR tracking arrays for compute workloads"
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "data_subnet_cidrs" {
  type        = list(string)
  description = "CIDR tracking arrays for managed Redis caches"
  default     = ["10.0.20.0/24", "10.0.21.0/24"]
}

variable "instance_type" {
  type        = string
  description = "EC2 computing tier type for the Backend Auto Scaling Group"
  default     = "t3.micro"
}

variable "domain_name" {
  type        = string
  description = "Root custom domain name configuration string"
  default     = "starttech.fanuel.pro.et"
}

variable "mongodb_uri" {
  description = "The MongoDB connection string"
  type        = string
  sensitive   = true
}