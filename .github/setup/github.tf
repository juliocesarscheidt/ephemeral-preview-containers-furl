data "tls_certificate" "github_actions_oidc_provider" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github_actions_oidc_provider.certificates[0].sha1_fingerprint]
}

# the role that the github action runs as
resource "aws_iam_role" "github_actions" {
  name               = "github-action-${var.github_repo}"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json
  inline_policy {
    name = "terraform"
    policy = templatefile("${path.module}/policy.tmpl", {
      Region  = var.region,
      Account = data.aws_caller_identity.current.account_id,
      Name    = var.github_repo,
      Bucket  = module.terraform_state_s3_bucket.s3_bucket_arn
    })
  }
}

data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_org}/${var.github_repo}:*"]
    }
  }
}
