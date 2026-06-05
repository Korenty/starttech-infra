# 1. ElastiCache Redis Subnet Group Configuration
resource "aws_elasticache_subnet_group" "redis_subnets" {
  name        = "${var.project_name}-${var.environment}-redis-subnet-group"
  subnet_ids  = var.data_subnet_ids
  description = "Binds ElastiCache clusters exclusively to isolated internal data subnets"
}

# 2. Production-Ready ElastiCache Redis Replication Group (Cluster Mode Disabled)
resource "aws_elasticache_replication_group" "redis" {
  replication_group_id        = "${var.project_name}-${var.environment}-redis"
  description                 = "High-availability session caching tier for StartTech application"
  node_type                   = "cache.t3.micro"
  port                        = 6379
  parameter_group_name        = "default.redis7"
  automatic_failover_enabled  = true
  multi_az_enabled            = true
  num_cache_clusters          = 2
  subnet_group_name           = aws_elasticache_subnet_group.redis_subnets.name
  security_group_ids          = [var.redis_sg_id]
  at_rest_encryption_enabled  = true
  transit_encryption_enabled = false # Set to true if application code supports TLS handles

  tags = {
    Name        = "${var.project_name}-${var.environment}-redis-cluster"
    Environment = var.environment
  }
}

# 3. Centralized CloudWatch Log Group for Application Components
resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/starttech/${var.environment}/backend-application"
  retention_in_days = 7

  tags = {
    Name        = "${var.project_name}-${var.environment}-log-group"
    Environment = var.environment
  }
}
