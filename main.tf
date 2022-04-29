# fetch the ubuntu ami (so that it works in multiple regions)
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# add your own keypair
resource "aws_key_pair" "key" {
  key_name   = "key"
  public_key = file(var.KEY)
}

# # change USERDATA varible value after grabbing RDS endpoint info
# data "template_file" "user_data" {
#   template = var.IsUbuntu ? file("./userdata_ubuntu.tpl") : file("./user_data.tpl")
#   vars = {
#     db_username      = var.database_user
#     db_user_password = var.database_password
#     db_name          = var.database_name
#     db_RDS           = aws_db_instance.wordpressdb.endpoint
#   }
# }


# Create EC2 ( only after RDS is provisioned)
# resource "aws_instance" "wordpressec2" {

#   subnet_id       = aws_subnet.prod-subnet-public-1.id
#   security_groups = ["${aws_security_group.ec2_allow_rule.id}"]
#   user_data       = data.template_file.user_data.rendered

# }

resource "aws_instance" "wordpress" {
  ami                    = data.aws_ami.ubuntu.id # "ami-05b891753d41ff88f" #ubuntu ami
  instance_type          = var.INSTANCE_TYPE
  vpc_security_group_ids = [aws_security_group.wordpress-sec-group.id]
  user_data              = file("wordpress_script.sh")
  key_name               = aws_key_pair.key.id
  tags = {
    Name = "wordpress"
  }
  # depends_on = [aws_db_instance.wordpressdb] # this will stop creating EC2 before RDS is provisioned
}

resource "aws_eip" "eip" {
  instance = aws_instance.wordpress.id
}

output "eip" {
  value = aws_eip.eip.public_ip
}

output "INFO" {
  value = "AWS Resources and Wordpress has been provisioned. Go to http://${aws_eip.eip.public_ip}"
}

resource "null_resource" "Wordpress_Installation_Waiting" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.PRIV_KEY_PATH)
    host        = aws_eip.eip.public_ip
  }


  provisioner "remote-exec" {
    inline = ["sudo tail -f -n0 /var/log/cloud-init-output.log| grep -q 'WordPress Installed'"]

  }
}