resource "aws_security_group" "Jenkin_SG" {
  name        = "Jenkin_SG"
  description = "Jenkins traffic"
  vpc_id      = var.vpc

 ingress {
    description = "Allow ssh access"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    description = "Allow ssh access"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    description = "Allow inbound traffic"
    from_port   = "8080"
    to_port     = "8080"
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
    Name = "Jenkin_SG"
  }
}


resource "aws_security_group" "Bastion_SG" {
  name        = "Bastion_SG"
  description = "Allow inbound traffic"
  vpc_id      = var.vpc

 ingress {
    description = "Allow ssh access"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 ingress {
    description = "Allow ssh access"
    from_port   = "443"
    to_port     = "443"
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
    Name = "Bastion_SG"
  }
}

resource "aws_security_group" "Sonarqube_SG" {
  name        = "Sonarqube"
  description = "Allow inbound traffic"
  vpc_id      = var.vpc

  ingress {
    description      = "Allow ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow sonarqube access"
    from_port        = 9000
    to_port          = 9000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Sonarqube_SG"
  }
}

resource "aws_security_group" "k8sNodes_SG" {
  name        = "k8sNodes_SG"
  description = "Allow Inbound traffic"
  vpc_id      = var.vpc

  ingress {
    description = "Allow ssh access"
    from_port   = 0
    to_port     = 65535
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
    Name = "k8sNodes_SG"
  }
}

resource "aws_security_group" "rds_SG" {
  name        = "rds"
  description = "Allow Inbound traffic"
  vpc_id      = var.vpc

  ingress {
    description = "Allow ssh access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    description = "Allow ssh access"
    from_port   = "22"
    to_port     = "22"
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
    Name = "rds_SG"
  }
}

# # create security group for the cluster
# resource "aws_security_group" "eks-SG" {
#   name        = "eks-SG"
#   description = "allow access on ports 22, 80, 443 and 8080"
#   vpc_id      = var.vpc

#   # allow access on port
#   ingress {
#     description = "ssh http and all port access"
#     from_port   = 0
#     to_port     = 65000
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "k8s-SG"
#   }
# }
