#!/bin/bash
sudo apt update
echo "pubkeyAcceptedkeyTypes=+ssh-rsa" | sudo tee -a /etc/ssh/sshd_config.d/10-insecure-rsa-keysig.conf
sudo systemctl reload sshd
echo "${prv-key}" | sudo tee /home/ubuntu/.ssh/id_rsa
sudo chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa
sudo chmod 400 /home/ubuntu/.ssh/id_rsa
sudo mkdir -p /home/ubuntu/.kube
sudo chown -R ubuntu:ubuntu /home/ubuntu/.kube/
sudo chown -R ubuntu:ubuntu /home/ubuntu/.kube/*
echo "${kubeconfig}" | sudo tee /home/ubuntu/.kube/config
sudo chmod 755 /home/ubuntu/.kube/config
sudo chmod 755 /home/ubuntu/.kube
sudo apt update
sudo apt install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sudo ln -svf /usr/local/bin/aws /usr/bin/aws
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.15.10/2020-02-22/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
sudo mv ./aws-iam-authenticator /usr/local/bin
sudo su -c "aws configure set aws_access_key_id ${access-key}" ubuntu
sudo su -c "aws configure set aws_secret_access_key ${secret-key}" ubuntu
sudo su -c "aws configure set region eu-west-2" ubuntu
sudo su -c "aws configure set output" ubuntu
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo mv /tmp/eksctl /usr/local/bin
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
echo "${file("./bastion/ingress.yaml")}" >> /home/ubuntu/ingress.yaml
echo "${file("./bastion/cluster-issuer-dns01")}" >> /home/ubuntu/cluster-issuer-dns01
sudo hostnamectl set-hostname Bastion




# sudo chown -R ubuntu:ubuntu /home/ubuntu/.kube/config
# sudo su -c "helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx" ubuntu
# sudo su -c "helm repo update" ubuntu
# aws eks --region ${region} update-kubeconfig --name ${cluster_name}
# docker pull username/repo/image/tag
# sudo groupadd docker
# sudo usermod -aG docker $USER
# add port in console
# https://index.docker.io/v1/
#   MYSQL_URL: "mysql://$(MYSQL_USER):$(MYSQL_PASSWORD)@mysql-svc:$(PMA_PORT)/$(MYSQL_DATABASE)"
