locals {
  jenkins_user_data = <<-EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install wget -y
sudo apt-get install git -y
sudo apt-get install maven -y
sudo apt install openjdk-11-jdk -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce -y
sudo apt install docker-ce -y
sudo chmod 400 /var/run/docker.sock
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ubuntu
echo "license_key: eu01xx31c21b57a02a5da0d33d8706beb182NRAL" | sudo tee -a /etc/newrelic-infra.yml
sudo curl -o /etc/yum.repos.d/newrelic-infra.repo https://download.newrelic.com/infrastructure_agent/linux/yum/el/7/x86_64/newrelic-infra.repo
sudo yum -q makecache -y --disablerepo='*' --enablerepo='newrelic-infra'
sudo yum install newrelic-infra -y --nobest
wget https://github.com/aquasecurity/trivy/releases/download/v0.18.3/trivy_0.18.3_Linux-64bit.deb
sudo dpkg -i trivy_0.18.3_Linux-64bit.deb
sudo snap install trivy
wget -qO- https://github.com/prometheus/node_exporter/releases/download/v1.8.0/node_exporter-1.8.0.linux-amd64.tar.gz | tar xz --strip-components=1 --directory=/usr/local/bin/ node_exporter-1.8.0.linux-amd64/node_exporter
sudo /usr/local/bin/node_exporter &
sudo hostnamectl set-hostname Jenkins-agent
EOF
}