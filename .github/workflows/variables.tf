variable "name" {
  type        = string
  description = "Name for the resources"
}

variable "environment" {
  type        = string
  description = "Environment for the resources"
}

variable "image_tag" {
  type        = string
  description = "Container image tag"
}
