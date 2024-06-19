#creating keypair
resource "tls_private_key" "keypair" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

#create local file for private keypair
resource "local_file" "keypair-file" {
  content  = tls_private_key.keypair.private_key_pem
  filename = "keypair.pem"
  file_permission = "600"
}

#creating public key resources
resource "aws_key_pair" "key_pair" {
  key_name   = "keypair"
  public_key = tls_private_key.keypair.public_key_openssh
}


# use data source to get a registered ubuntu ami
data "aws_ami" "eks-ami" {

  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
