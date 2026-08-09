#!/bin/bash

set -e

echo "======================================"
echo " Multi-Cloud DevOps Tools Installation"
echo "======================================"

sudo apt-get update -y

echo "[1/8] Installing basic packages..."
sudo apt-get install -y \
    curl \
    wget \
    unzip \
    git \
    jq \
    ca-certificates \
    gnupg \
    lsb-release \
    apt-transport-https

echo "[2/8] Installing AWS CLI..."

if ! command -v aws >/dev/null 2>&1; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
        -o /tmp/awscliv2.zip

    unzip -q /tmp/awscliv2.zip -d /tmp

    sudo /tmp/aws/install

    rm -rf /tmp/aws /tmp/awscliv2.zip
fi

aws --version


echo "[3/8] Installing Docker..."

if ! command -v docker >/dev/null 2>&1; then
    sudo apt-get install -y docker.io

    sudo systemctl enable docker
    sudo systemctl start docker

    sudo usermod -aG docker "$USER"
fi

docker --version


echo "[4/8] Installing kubectl..."

if ! command -v kubectl >/dev/null 2>&1; then
    curl -LO \
    "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

    rm -f kubectl
fi

kubectl version --client


echo "[5/8] Installing Helm..."

if ! command -v helm >/dev/null 2>&1; then
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
        | bash
fi

helm version --short


echo "[6/8] Installing Terraform..."

if ! command -v terraform >/dev/null 2>&1; then

    wget -qO- https://apt.releases.hashicorp.com/gpg \
        | gpg --dearmor \
        | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

    sudo chmod 644 /usr/share/keyrings/hashicorp-archive-keyring.gpg

    echo \
"deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com \
$(lsb_release -cs) main" \
    | sudo tee /etc/apt/sources.list.d/hashicorp.list

    sudo apt-get update -y
    sudo apt-get install -y terraform
fi

terraform version


echo "[7/8] Installing Ansible..."

if ! command -v ansible >/dev/null 2>&1; then
    sudo apt-get install -y ansible
fi

ansible --version | head -1


echo "[8/8] Checking Git..."

git --version


echo ""
echo "======================================"
echo " Installation Complete"
echo "======================================"

echo ""
echo "Installed tools:"
echo "AWS CLI   : $(aws --version 2>&1)"
echo "Docker    : $(docker --version)"
echo "kubectl   : $(kubectl version --client --short 2>/dev/null || kubectl version --client)"
echo "Helm      : $(helm version --short)"
echo "Terraform : $(terraform version | head -1)"
echo "Ansible   : $(ansible --version | head -1)"
echo "Git       : $(git --version)"
echo ""
echo "AWS configuration:"
echo "Run: aws configure"
echo ""
echo "Docker group:"
echo "Run: newgrp docker"