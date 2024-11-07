#!/bin/bash
# Setup for Control Plane (Master) server in AWS
set -euxo pipefail

# Variables
NODENAME=$(hostname -s)
POD_CIDR="192.168.0.0/16"
SERVICE_CIDR="10.96.0.0/12"

# Get private IP
MASTER_PRIVATE_IP=$(hostname -I | awk '{print $1}')
echo "Master IP: $MASTER_PRIVATE_IP"

# Create kube user
sudo useradd -m -s /bin/bash kube
sudo usermod -aG sudo kube
echo "kube ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/kube

# Pull required images
sudo kubeadm config images pull

# Initialize kubeadm
sudo kubeadm init \
  --apiserver-advertise-address="$MASTER_PRIVATE_IP" \
  --apiserver-cert-extra-sans="$MASTER_PRIVATE_IP" \
  --pod-network-cidr="$POD_CIDR" \
  --service-cidr="$SERVICE_CIDR" \
  --node-name "$NODENAME" \
  --ignore-preflight-errors=Swap

# Configure kubeconfig for kube user
sudo mkdir -p /home/kube/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/kube/.kube/config
sudo chown -R kube:kube /home/kube/.kube
sudo chmod 600 /home/kube/.kube/config

# Set KUBECONFIG environment variable for kube user
echo "export KUBECONFIG=/home/kube/.kube/config" | sudo tee -a /home/kube/.bashrc

# Switch to kube user for remaining operations
sudo -i -u kube bash << 'EOF'
export KUBECONFIG=/home/kube/.kube/config

# Install Calico Network Plugin
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml

# Wait for api-server to be up
until kubectl get nodes; do
  echo "Waiting for API server to be available..."
  sleep 5
done

echo "#!/bin/bash" > /tmp/kubeadm_join_cmd.sh
kubeadm token create --print-join-command >> /tmp/kubeadm_join_cmd.sh
chmod +x /tmp/kubeadm_join_cmd.sh
EOF