output "alb_dns_name" {
  value       = aws_lb.external_alb.dns_name
  description = "The external routing address address for front-end ingestion systems"
}

output "alb_arn" {
  value       = aws_lb.external_alb.arn
  description = "The unique Resource Name reference tracking the load balancer"
}

output "asg_name" {
  value       = aws_autoscaling_group.backend_asg.name
  description = "The tracking identifier of the provisioned Auto Scaling Group"
}
