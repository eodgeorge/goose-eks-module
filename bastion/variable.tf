variable "ami" {}
variable "bastion-SG" {}
variable "key_name" {}
variable "public-subnet" {}
variable "kubeconfig" {}
variable "access-key" {}   
variable "secret-key" {}    
variable "prv-key" {}  
variable "regions" {}  
variable "cluster_name" {}  





# [templatefile("${path.module}/bastion/cluster-issuer-dns01" >> /home/ubuntu/cluster-issuer-dns01, {})]
# [templatefile("${path.module}/bastion/ingress" >> /home/ubuntu/ingress, {})]