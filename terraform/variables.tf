variable "aws_region" {}
variable "aws_account_id" {}
variable "vpc_id" {}
variable "subnets" {}
variable "image_repo_name" {}
variable "image_tag" {}
variable "image_repo_url" {}
variable "role" {}
variable "cluster_name" {
  default = "flask-app-cluster"
}
variable "app_id" {}
variable "app_env" {}

locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Service     = var.app_id
    Environment = var.app_env
    Owner       = "DevOps Team"
  }
}