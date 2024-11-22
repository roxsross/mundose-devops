module "terraform-docker-nginx" {
  source = "../terraform-docker-nginx"
  #source = "git::git@github.com:roxsross/modules.git//app?ref=v0.1.0"
  container_name = "mundse-nginx"
  mapping_port   = 8081
}