#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -o pipefail

echo " Starting installation of Docker, Kind, and kubectl on CentOS 10..."

# ----------------------------
# 1. Install Docker (Docker CE)
# ----------------------------
if ! command -v docker &>/dev/null; then
  echo "==> Installing Docker... <=="
  
  # Install dependencies for repository management
  sudo dnf install -y yum-utils
  
  # Add Docker's official CentOS repository
  sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  
  # Install Docker Engine and CLI
  sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  echo "==> Starting and enabling Docker service... <=="
  sudo systemctl enable --now docker

  echo "==> Adding current user to docker group... <=="
  # Create group if it doesn't exist, then add user
  sudo groupadd -f docker
  sudo usermod -aG docker "$USER"

  echo " ~~~~Docker installed, started and user added to docker group~~~~"
else
  echo " ~~~~Docker is already installed~~~~"
fi

# ----------------------------
# 2. Install Kind (Binary download is OS-agnostic)
# ----------------------------
if ! command -v kind &>/dev/null; then
  echo "==> Installing Kind... <=="

  ARCH=$(uname -m)
  # Map CentOS architecture names to Kind binary names
  if [ "$ARCH" = "x86_64" ]; then
    KIND_ARCH="amd64"
  elif [ "$ARCH" = "aarch64" ]; then
    KIND_ARCH="arm64"
  else
    echo "==> Unsupported architecture: $ARCH <=="
    exit 1
  fi

  curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-${KIND_ARCH}"
  chmod +x ./kind
  sudo mv ./kind /usr/local/bin/kind
  echo "==> Kind installed successfully. <=="
else
  echo "==> Kind is already installed.<=="
fi

# ----------------------------
# 3. Install kubectl
# ----------------------------
if ! command -v kubectl &>/dev/null; then
  echo "==> Installing kubectl... <=="

  ARCH=$(uname -m)
  VERSION=$(curl -Ls https://dl.k8s.io/release/stable.txt)

  if [ "$ARCH" = "x86_64" ]; then
    K_ARCH="amd64"
  elif [ "$ARCH" = "aarch64" ]; then
    K_ARCH="arm64"
  else
    echo "==> Unsupported architecture: $ARCH <=="
    exit 1
  fi

  curl -Lo ./kubectl "https://dl.k8s.io/release/${VERSION}/bin/linux/${K_ARCH}/kubectl"
  chmod +x ./kubectl
  sudo mv ./kubectl /usr/local/bin/kubectl
  echo "==> kubectl installed successfully. <=="
else
  echo "==> kubectl is already installed. <=="
fi

# ----------------------------
# 4. Confirm Versions
# ----------------------------
echo
echo "==> Installed Versions: <=="
docker --version
kind --version
kubectl version --client

echo
echo " |||| IMPORTANT: Run 'newgrp docker' or log out/in to use Docker without sudo. ||||"
echo " |||| Installation complete! ||||"
