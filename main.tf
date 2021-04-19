provider "aws" {
  profile = "default"
  region  = "ap-southeast-1"
}

resource "aws_instance" "wordpress" {
  ami           = "ami-05b891753d41ff88f" #ubuntu ami
  instance_type = "t2.micro"
  vpc_security_group_ids = ["sg-063201222659c5915"]
  user_data = file("script.sh")
  key_name = "Rajat"
  tags = { 
    Name = "wordpress"
  }
}