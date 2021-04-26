resource "aws_security_group" "wordpress-sec-group" {
  name        = "wordpress-sec-group"
  description = "Simple wordpress security group with ssh, http and, https enabled"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Default Wordpress SG"
  }
}

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
