# Global
variable "region" {}
variable "name_prefix" {}

# ECR
variable "account_id" {}

locals {
  repository_name = "${var.name_prefix}-repository"
  container_name  = "${var.name_prefix}-container"
}
