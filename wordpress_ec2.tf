resource "aws_instance" "wordpress" {
  ami           = "ami-05b891753d41ff88f" #ubuntu ami
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.wordpress-sec-group.id]
  user_data = file("wordpress_script.sh")
  key_name = var.key_name
  tags = { 
    Name = "wordpress"
  }
}
