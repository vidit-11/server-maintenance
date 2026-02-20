#!/bin/bash
echo " Starting cleanup of Docker, Kind, and kubectl..."

# 1. Remove Binaries (Kind and Kubectl)
echo " Removing Kind and Kubectl binaries..."
sudo rm -f /usr/local/bin/kind
sudo rm -f /usr/local/bin/kubectl

# 2. Stop and Remove Docker
echo " Stopping Docker services..."
sudo systemctl disable --now docker.service containerd.service || true

echo " Uninstalling Docker packages..."
sudo dnf remove -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

# 3. Cleanup Configuration and Repos
echo " Removing Docker repository and data..."
sudo rm -f /etc/yum.repos.d/docker-ce.repo
# WARNING: This deletes all your Docker images, containers, and volumes!
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

# 4. Remove User Group (Optional)
echo " Removing docker group from user..."
sudo gpasswd -d "$USER" docker || true

echo " System is back to its original state (mostly)!"
