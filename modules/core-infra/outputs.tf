
output "alb_host_name" {
  value = aws_alb.application_load_balancer.dns_name
}
