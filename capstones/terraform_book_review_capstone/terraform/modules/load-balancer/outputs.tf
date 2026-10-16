output "public_alb_dns_name" {
  description = "DNS name of the public ALB (internet-facing entry point)"
  value       = aws_lb.public.dns_name
}

output "public_alb_arn" {
  description = "ARN of the public ALB"
  value       = aws_lb.public.arn
}

output "internal_alb_dns_name" {
  description = "DNS name of the internal ALB (Web tier -> App tier). Consumed by Phase 5/6 for the backend base URL."
  value       = aws_lb.internal.dns_name
}

output "internal_alb_arn" {
  description = "ARN of the internal ALB"
  value       = aws_lb.internal.arn
}

output "internal_alb_target_group_arn" {
  description = "ARN of the backend (App tier) target group. Consumed by Phase 5 to attach EC2 instances."
  value       = aws_lb_target_group.backend.arn
}

output "web_target_group_arn" {
  description = "ARN of the web (Web tier) target group. Consumed by Phase 5 to attach EC2 instances."
  value       = aws_lb_target_group.web.arn
}
