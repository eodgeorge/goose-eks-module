# output "certificate_authority_data" {
#   value = module.eks.cluster_certificate_authority_data
# }

output "cluster_name" {
  value = module.eks.cluster_name
}

# output "cluster_endpoint" {
#   value = module.eks.cluster_endpoint
# }

output "bastion-server" { value = module.bastion.bastion-publicIP }

output "jenkins-contrl-server" { value = module.jenkins.jenkins-contrl-ip }

output "jenkins-agent-server" { value = module.jenkins.jenkins-agent-ip }

output "sonar-server" { value = module.sonarqube.sonar-server }

output "rds-endpoint" { value = module.rds.rds-endpoint }

output "rds-address" { value = module.rds.rds-address }

output "nginx_ingress_lb_dns" {
  value = try(data.kubernetes_service.nginx_ingress.status.0.load_balancer.0.ingress.0.hostname, null)
}

# terraform apply -var-file=stage.tfvars -auto-approve
# kubectl create secret generic mysql-secret --type=opaque 
# --from-literal=MYSQL_ROOT_PASSWORD=secrets --from-literal=MYSQL_DATABASE=petclinic 
# --from-literal=MYSQL_USER=petclinic --from-literal=MYSQL_PASSWORD=p[Betclinic --dry-run=client -o yaml 
#  kubectl port-forward service/phpmyadmin --address 0.0.0.0 8092:80
#   echo c2VjcmV0cw== | base64 -d    echo -n petclinic | base64



# output "nginx_ingress_lb_dns" {
#   value = [for svc in data.kubernetes_service.nginx_ingress.status : svc.load_balancer[0].ingress[0].hostname]
#   description = "DNS name Nginx Ingress LB"
# }
# TF_LOG=ERROR terraform apply -var-file=stage.tfvars -auto-approve


