variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "github_org" {
  description = "Name of the github organization"
  type        = string
}

variable "github_repo" {
  description = "Name of the github repo"
  type        = string
}
