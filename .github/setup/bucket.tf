resource "random_string" "random_str" {
  length  = 6
  special = false
  lower   = true
  upper   = false
}

# s3 bucket for terraform state
module "terraform_state_s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"
  bucket  = "tf-state-${data.aws_caller_identity.current.account_id}-${random_string.random_str.result}"

  attach_deny_insecure_transport_policy = true
  attach_require_latest_tls_policy      = true
  acl                                   = "private"
  block_public_acls                     = true
  block_public_policy                   = true
  ignore_public_acls                    = true
  restrict_public_buckets               = true
  control_object_ownership              = true
  object_ownership                      = "BucketOwnerPreferred"

  versioning = {
    status     = true
    mfa_delete = false
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}
