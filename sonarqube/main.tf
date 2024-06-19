resource "aws_instance" "sonarqube-server" {
  ami                       = var.ami
  vpc_security_group_ids    = [var.sonarqube-SG]
  instance_type             = "t2.medium"
  key_name                  = var.key_name
  subnet_id                 = var.public-subnet
  associate_public_ip_address = true
  user_data                   = file("./sonarqube/sonar.sh")

  user_data_replace_on_change = true

  tags = {
    Name = "sonar-server"
 }
}