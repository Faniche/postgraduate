#!/bin/bash
PROXY_ADDRESS="http://10.100.0.1:1080"

# Uninstall old versions
echo 'Uninstall old versions...'
sudo apt-get remove docker docker-engine docker.io containerd runc

# Set up the repository
echo 'Set up the repository'

# 1. Update the apt package index and install packages to allow apt to use a repository over HTTPS
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y
# 2. Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# 3. Add repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Install Docker Engine
echo 'Intall docker engine...'
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
echo 'Verify that Docker Engine...'
echo 'Setting docker proxy'
echo 'echo 'Environment="HTTP_PROXY='$PROXY_ADDRESS'"' >> /lib/systemd/system/docker.service' | sudo sh

# Set up the Docker daemon
touch /home/${USER}/daemon.json
cat > /home/${USER}/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
sudo mv /home/${USER}/daemon.json /etc/docker/
sudo mkdir -p /etc/systemd/system/docker.service.d

# Add current user to docker group
# Create the docker group
sudo groupadd docker
# Add your user to the docker group.
sudo usermod -aG docker $USER
# activate the changes to groups:
newgrp docker

echo 'Restarting Docker...'
sudo systemctl daemon-reload
sudo systemctl restart docker
docker run hello-world

