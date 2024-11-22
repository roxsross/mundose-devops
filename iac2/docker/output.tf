output "container_id" {
  description = "Container ID"
  value       = docker_container.name.id
}

output "url" {
  description = "URL accesso a nginx"
  value       = "http://localhost:${var.mapping_port}"

}