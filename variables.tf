variable "region" {
  description = "Azure infrastructure region"
  type        = string
  default     = "West Europe"
}

variable "app" {
  description = "Application that we want to deploy"
  type        = string
  default     = "snapshare"
}


# dev, prod
variable "env" {
  description = "Application env"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Location short name "
  type        = string
  default     = "we"
}


variable "prefix" {
  description = "Prefix for containers"
  type        = string
  default     = "testing"
}