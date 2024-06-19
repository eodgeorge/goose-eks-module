output "private-key" { value = tls_private_key.keypair.private_key_pem }
output "public-key" { value = aws_key_pair.key_pair.id }
output "eks-ami-id" { value = data.aws_ami.eks-ami.id }
