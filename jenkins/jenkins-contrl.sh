#!/bin/bash
sudo apt-get update
sudo apt-get install wget -y
sudo apt-get install git -y
sudo apt-get install maven -y
sudo apt install openjdk-11-jdk -y
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo chown -R ubuntu:ubuntu /etc/hosts
sudo mkdir /var/lib/jenkins/.ssh/
sudo chown -R jenkins:jenkins /var/lib/jenkins/.ssh
sudo chmod 755 /var/lib/jenkins/.ssh/*
echo "${agent_ip} jenkins-agent" >> /etc/hosts
sudo ssh-keyscan -H jenkins-agent >> /var/lib/jenkins/.ssh/known_hosts
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo chmod 755 /var/run/docker.sock
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
wget https://github.com/aquasecurity/trivy/releases/download/v0.18.3/trivy_0.18.3_Linux-64bit.deb
sudo dpkg -i trivy_0.18.3_Linux-64bit.deb
sudo snap install trivy
sudo mkdir -p /home/ubuntu/.kube
sudo chown -R ubuntu:ubuntu /home/ubuntu/.kube/
sudo chown -R ubuntu:ubuntu /home/ubuntu/.kube/*
echo "${kubeconfig}" | sudo tee /home/ubuntu/.kube/config
sudo chmod 755 /home/ubuntu/.kube/config
sudo chmod 755 /home/ubuntu/.kube
sudo apt install unzip
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
sudo hostnamectl set-hostname Jenkins-controller



# sudo snap install helm --classic
# sudo unzip -o spring-petclinic-2.4.3.war -d spring-petclinic-2.4.3
# # trivy fs --severity HIGH,CRITICAL spring-petclinic-2.4.3
# # #port mapping in docker
# sudo su -c "helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx" ubuntu
# sudo su -c "helm repo update" ubuntu
# aws eks --region ${region} update-kubeconfig --name ${cluster_name}