# 1. Define Terraform Engine & Core AWS Provider Restrictions
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# 2. Module 1: Core Networking & Security Firewalls
module "networking" {
  source = "./modules/networking"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  data_subnet_cidrs    = var.data_subnet_cidrs
}

# 3. Module 2: Auto Scaling Compute Tier & Load Balancers
module "compute" {
  source = "./modules/compute"

  project_name       = var.project_name
  environment        = var.environment
  instance_type      = var.instance_type
  vpc_id             = module.networking.vpc_id
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
  alb_sg_id          = module.networking.alb_sg_id
  backend_sg_id      = module.networking.backend_sg_id
}

# 4. Module 3: Frontend Storage Bucket & Edge CloudFront CDN
module "storage" {
  source = "./modules/storage"

  project_name = var.project_name
  environment  = var.environment
  domain_name  = var.domain_name
}

# 5. Module 4: High-Availability Session Caching & Central Logging
module "monitoring" {
  source = "./modules/monitoring"

  project_name    = var.project_name
  environment     = var.environment
  data_subnet_ids = module.networking.data_subnet_ids
  redis_sg_id     = module.networking.redis_sg_id
}
