output "nginx_public_ip" {
  description = "Public IP of the created Nginx instance"
  value       = module.nginx_server.public_ip
}
