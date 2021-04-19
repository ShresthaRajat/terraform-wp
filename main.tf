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
# resource "aws_db_instance" "default" {
#   identifier           = "sample"
#   allocated_storage    = 20
#   storage_type         = "gp2"
#   engine               = "mysql"
#   engine_version       = "5.7"
#   instance_class       = "db.t2.micro"
#   name                 = "wordpress"
#   username             = "root"
#   password             = "redhat123"
#   publicly_accessible  = true
#   skip_final_snapshot  = true
# } 