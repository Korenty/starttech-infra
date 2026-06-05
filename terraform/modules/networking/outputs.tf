output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The provisioned main tracking identifier reference"
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "The primary array capturing public subnet identifiers"
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "The primary array capturing private compute subnet identifiers"
}

output "data_subnet_ids" {
  value       = aws_subnet.data[*].id
  description = "The primary array capturing isolated caching subnet identifiers"
}

output "alb_sg_id" {
  value       = aws_security_group.alb.id
  description = "The edge proxy control barrier identifier reference"
}

output "backend_sg_id" {
  value       = aws_security_group.backend.id
  description = "The compute tier control barrier identifier reference"
}

output "redis_sg_id" {
  value       = aws_security_group.redis.id
  description = "The data tier control barrier identifier reference"
}
