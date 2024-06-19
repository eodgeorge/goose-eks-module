resource "aws_instance" "jenkins-controller" {
  ami                       = var.ami
  vpc_security_group_ids    = [var.jenkins-SG]
  instance_type             = "t2.medium"
  key_name                  = var.key_name
  subnet_id                 = var.private-subnet
  associate_public_ip_address = true
  user_data                 = templatefile("./jenkins/jenkins-contrl.sh", { 
    agent_ip                = var.agent_ip
    kubeconfig              = var.kubeconfig
    access-key              = var.access-key
    secret-key              = var.secret-key
    region                  = var.regions
    cluster_name            = var.cluster_name
    })

  user_data_replace_on_change = true

  tags = {
    Name = "jenkins-controller"
 }
}



resource "aws_instance" "jenkins-agent" {
  ami                       = var.ami
  vpc_security_group_ids    = [var.jenkins-SG]
  instance_type             = "t2.micro"
  key_name                  = var.key_name
  subnet_id                 = var.private-subnet
  associate_public_ip_address = true
  user_data                 = local.jenkins_user_data

  user_data_replace_on_change = true

  tags = {
    Name = "jenkins-agent"
  }
}