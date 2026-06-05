output "s3_bucket_name" {
  value       = aws_s3_bucket.frontend.id
  description = "The dynamically provisioned unique name string of the bucket"
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.frontend.arn
  description = "The unique Amazon Resource Name pointing to the bucket"
}

output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
  description = "The native global CDN routing address for the application bundle"
}

output "cloudfront_distribution_id" {
  value       = aws_cloudfront_distribution.s3_distribution.id
  description = "The unique tracking reference managing the distribution states"
}
