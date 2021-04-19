provider "aws" {
  profile = "default"
  # region  = var.region
  region  = "ap-southeast-1"
}

terraform {
  required_version = "0.14.10"
}