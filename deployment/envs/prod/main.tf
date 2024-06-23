terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  backend "s3" {
    bucket         = "terraform-blue-green-bucket-20240622"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
    dynamodb_table = "terraform-blue-green-terraform-locks"
  }
}

# ECR
module "ecr" {
  source = "../../modules/ecr"

  name_prefix = var.name_prefix
  region      = var.region
  account_id  = var.account_id
}

# IAM
module "iam" {
  source = "../../modules/iam"

  name_prefix = var.name_prefix
  region      = var.region
}

# Network
module "network" {
  source = "../../modules/network"

  name_prefix = var.name_prefix
  region      = var.region
}

# Security Group
module "sg" {
  source = "../../modules/sg"

  name_prefix = var.name_prefix
  region      = var.region

  vpc_id = module.network.vpc_id
  # sg_ingress_ip_cidr = var.sg_ingress_ip_cidr
}

# ALB
module "alb" {
  source = "../../modules/alb"

  name_prefix = var.name_prefix
  region      = var.region

  vpc_id      = module.network.vpc_id
  public_a_id = module.network.public_subnet_a_id
  public_c_id = module.network.public_subnet_c_id
  sg_id       = module.sg.sg_id
}

# ECS
module "ecs" {
  source = "../../modules/ecs"

  name_prefix = var.name_prefix
  region      = var.region
  webapp_port = 80

  # Service
  tg_arn      = module.alb.tg_arn
  public_a_id = module.network.public_subnet_a_id
  public_c_id = module.network.public_subnet_c_id
  sg_id       = module.sg.sg_id
  # Task
  ecr_repository_uri = module.ecr.repository_uri
  execution_role_arn = module.iam.execution_role_arn
}
