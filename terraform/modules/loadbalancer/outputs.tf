output "lb_url" {
  value       = aws_lb.ec2_lb.dns_name
  description = "URL pública do Load Balancer"
}
