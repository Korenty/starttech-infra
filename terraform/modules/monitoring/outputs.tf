output "redis_endpoint" {
  value       = aws_elasticache_replication_group.redis.primary_endpoint_address
  description = "The primary host link used by the backend API connection engine"
}

output "log_group_name" {
  value       = aws_cloudwatch_log_group.app_logs.name
  description = "The absolute string path tracking the centralized log repository"
}
