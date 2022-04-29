provider "aws" {
  profile = "default"
  region  = var.REGION
}

terraform {
  required_version = ">= 0.15"
}