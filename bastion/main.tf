resource "aws_instance" "bastion-host" {
  ami                       = var.ami
  vpc_security_group_ids    = [var.bastion-SG]
  instance_type             = "t2.micro"
  key_name                  = var.key_name
  subnet_id                 = var.public-subnet
  associate_public_ip_address = true
  user_data                 = templatefile("./bastion/bastion.sh", {
  # user_data                 = templatefile("${path.root}/bastion.sh", {
    prv-key                 = var.prv-key
    kubeconfig              = var.kubeconfig
    access-key              = var.access-key
    secret-key              = var.secret-key 
    region                  = var.regions
    cluster_name            = var.cluster_name
  })
  user_data_replace_on_change = true

  tags = {
    Name = "bastion-host"
  }
}


