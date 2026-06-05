output "vpc_id" {
  value       = module.networking.vpc_id
  description = "The provisioned main Virtual Private Cloud unique identifier"
}

output "alb_dns_name" {
  value       = module.compute.alb_dns_name
  description = "The public external DNS record address of the Backend Ingress ALB"
}

output "s3_bucket_name" {
  value       = module.storage.s3_bucket_name
  description = "The globally unique identifier string of the Frontend S3 Bucket"
}

output "cloudfront_domain_name" {
  value       = module.storage.cloudfront_domain_name
  description = "The secure global Edge distribution URL for the React static bundle"
}

output "redis_endpoint" {
  value       = module.monitoring.redis_endpoint
  description = "The primary connection endpoint string for the ElastiCache cluster"
}
