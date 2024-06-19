output "rds_secret_arn" {
  value = aws_secretsmanager_secret.rds_secret.arn
}

output "rds_secret_string" {
  value = aws_secretsmanager_secret_version.rds_secret_version.secret_string
}

