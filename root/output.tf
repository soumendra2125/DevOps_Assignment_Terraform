output "Frontend_public_IP_Address" {
  value = module.ec2.frontend_ip
}
output "Backend_public_IP_Address" {
  value = module.ec2.backend_ip
}
