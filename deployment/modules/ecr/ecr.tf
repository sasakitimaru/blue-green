resource "aws_ecr_repository" "default" {
  name                 = local.repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "null_resource" "default" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "sh ${path.module}/dockerbuild.sh"

    environment = {
      AWS_REGION     = var.region
      AWS_ACCOUNT_ID = var.account_id
      REPO_URL       = aws_ecr_repository.default.repository_url
      CONTAINER_NAME = "${local.container_name}"
      DOCKER_DIR     = "${path.module}"
      TARGET_STAGE   = "prod-server"
    }
  }
}
