variable "aws_region" {
  type      = string
  default   = "us-east-1"
}
variable "ruta_private_key" {
  description "Ruta del archivo PEM para conexión SSH."
  type = string
}
