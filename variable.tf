variable "REGION" {
  default = "eu-west-2"
}

variable "KEY" {
  default = "ID_RSA.pub"
}

variable "INSTANCE_TYPE" {
  default = "t2.micro"
}

variable "VPC_CIDR" {
  default = "10.0.0.0/16"
}

variable "SUBNET_1_CIDR" {
  default = "10.0.1.0/24"
}

variable "AZ1" {
  default = ""
}

variable "PRIV_KEY_PATH" {
  default = "./ID_RSA"
}