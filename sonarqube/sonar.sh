#!/bin/bash
sudo apt-get update
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt-get update
apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo chmod 755 /var/run/docker.sock
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
sudo docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube
sudo hostnamectl set-hostname sonar-server