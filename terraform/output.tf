# Referência ao output do módulo de loadbalancer
output "lb_url" {
  value       = module.loadbalancer.lb_url
  description = "URL pública do Load Balancer"
}
