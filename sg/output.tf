output "jenkins-sg-id" { value = aws_security_group.Jenkin_SG.id }
output "Bastion_SG-id" { value = aws_security_group.Bastion_SG.id }
output "Sonarqube_SG-id" { value = aws_security_group.Sonarqube_SG.id }
output "k8sNodes_SG-id" { value = aws_security_group.k8sNodes_SG.id }
output "rds_SG-id" { value = aws_security_group.rds_SG.id }
# output "eks-sg-id" { value = aws_security_group.eks-SG.id }