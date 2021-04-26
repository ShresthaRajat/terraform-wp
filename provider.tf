provider "aws" {
  profile = "default"
  region  = var.region
}

terraform {
  required_version = ">= 0.15"
}