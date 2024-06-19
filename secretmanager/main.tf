resource "aws_secretsmanager_secret" "rds_secret" {
  name                     = "rdds-credentials"
  recovery_window_in_days  = 0
}

resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id     = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    username = var.username
    password = var.password
  })
}
