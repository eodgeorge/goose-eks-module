
resource "aws_db_subnet_group" "rds" {
subnet_ids = var.private-subnet

  tags = {
    Name = "rds-subnet-group"
  }
}

resource "aws_db_instance" "rds-server" {
  allocated_storage           = 10
  db_subnet_group_name        = aws_db_subnet_group.rds.name
  engine                      = "mysql"
  engine_version              = "8.0"
  identifier                  = "mysql-rdds"
  instance_class              = "db.t3.micro"
  multi_az                    = false
  db_name                     = "petclinic"
  password                    = var.password
  username                    = var.username
  storage_type                = "gp2"
  vpc_security_group_ids      = [var.rds-SG]
  publicly_accessible         = false
  skip_final_snapshot         = true
  parameter_group_name        = "default.mysql8.0"

   tags = {
    Name = "rds-server"
  }
}