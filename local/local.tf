
####recurso
resource "local_file" "archivo1" {
  content  = "Hola mundo aleatorio: ${random_string.datos_aleatorios.result}"
  filename = var.file
}

resource "random_string" "datos_aleatorios" {
  length  = 8
  special = false
  upper   = true
  lower   = true
  numeric = true
}