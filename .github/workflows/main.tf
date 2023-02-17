module "docker_image" {
  source = "terraform-aws-modules/lambda/aws//modules/docker-build"

  create_ecr_repo = true
  ecr_repo        = local.ns
  image_tag       = var.image_tag
  source_path     = "../../"
}

module "lambda_function_from_container_image" {
  source = "terraform-aws-modules/lambda/aws"

  function_name              = local.ns
  description                = "Ephemeral preview environment for: ${local.ns}"
  create_package             = false
  package_type               = "Image"
  image_uri                  = module.docker_image.image_uri
  architectures              = ["x86_64"]
  create_lambda_function_url = true
}

output "endpoint_url" {
  value = module.lambda_function_from_container_image.lambda_function_url
}
