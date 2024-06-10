#!/bin/bash

# Update the package list and install prerequisites
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl

# Install Docker's official GPG key and add Docker repository
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package list and install Docker
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify Docker installation
sudo docker run hello-world

# Docker post-installation steps: running without sudo
sudo groupadd docker
sudo gpasswd -a $USER docker
newgrp docker

# Verify Docker can run without sudo
docker run hello-world
docker image ls

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify Docker Compose installation
docker-compose --version

# Install Git
sudo apt-get install -y git

# Create directories for the projects
mkdir -p ~/nginx-docker ~/nginx-docker-compose ~/nginx-unique-docker-compose

# Create a sample index.html file for the Nginx container
echo "<!DOCTYPE html>
<html>
<head>
  <title>My Nginx Server</title>
</head>
<body>
  <h1>Hello, world!</h1>
</body>
</html>" > ~/nginx-docker/index.html

# Create a Dockerfile for the Nginx container
echo "FROM nginx:stable-alpine
COPY . /usr/share/nginx/html
EXPOSE 80
CMD [\"nginx\", \"-g\", \"daemon off;\"]" > ~/nginx-docker/Dockerfile

# Build the Docker image
cd ~/nginx-docker
docker build -t my-nginx-container .

# Run the Docker container
docker run -d -p 8080:80 my-nginx-container

# Create a Docker Compose file for 5 identical Nginx containers
echo "version: '3.8'
services:
  web:
    image: my-nginx-container
    ports:
      - \"8080:80\"
    deploy:
      replicas: 5
      resources:
        limits:
          cpus: \"0.1\"
          memory: \"50M\"
      restart_policy:
        condition: on-failure" > ~/nginx-docker-compose/docker-compose.yml

# Run Docker Compose for identical containers
cd ~/nginx-docker-compose
docker-compose up -d

# Create a Docker Compose file for 5 unique Nginx containers
echo "version: '3.8'
services:
  web1:
    image: my-nginx-container
    ports:
      - \"8081:80\"
    environment:
      - TITLE=Service 1

  web2:
    image: my-nginx-container
    ports:
      - \"8082:80\"
    environment:
      - TITLE=Service 2

  web3:
    image: my-nginx-container
    ports:
      - \"8083:80\"
    environment:
      - TITLE=Service 3

  web4:
    image: my-nginx-container
    ports:
      - \"8084:80\"
    environment:
      - TITLE=Service 4

  web5:
    image: my-nginx-container
    ports:
      - \"8085:80\"
    environment:
      - TITLE=Service 5" > ~/nginx-unique-docker-compose/docker-compose.yml

# Run Docker Compose for unique containers
cd ~/nginx-unique-docker-compose
docker-compose up -d

echo "Setup complete. Visit the following URLs to check your services:
- http://your-instance-ip-address:8080 (identical containers)
- http://your-instance-ip-address:8081 (unique container 1)
- http://your-instance-ip-address:8082 (unique container 2)
- http://your-instance-ip-address:8083 (unique container 3)
- http://your-instance-ip-address:8084 (unique container 4)
- http://your-instance-ip-address:8085 (unique container 5)"
