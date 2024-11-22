resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = false
}
#docker run
resource "docker_container" "name" {
  name    = var.container_name
  image   = docker_image.nginx.image_id
  restart = "unless-stopped"

  ports {
    internal = 80
    external = var.mapping_port
    ip       = "0.0.0.0"
  }
  upload {
    content = <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to Nginx</title>
</head>
<body>
    <h1>Hello from Terraform-managed Nginx!</h1>
    <p>This page is served by Nginx container.</p>
</body>
</html>
    EOF
    file    = "/usr/share/nginx/html/index.html"
  }
}