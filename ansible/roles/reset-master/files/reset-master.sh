#!/bin/bash
set -euxo pipefail

# Reset kubeadm
echo "yes" | sudo kubeadm reset


# Get public IP
MASTER_PUBLIC_IP=$(curl -s ifconfig.me)
NODENAME=$(hostname -s)

# Initialize again
sudo kubeadm init \
  --control-plane-endpoint="$MASTER_PUBLIC_IP" \
  --apiserver-cert-extra-sans="$MASTER_PUBLIC_IP" \
  --pod-network-cidr=192.168.0.0/16 \
  --service-cidr=10.96.0.0/12 \
  --kubernetes-version=v1.31.0 \
  --node-name "$NODENAME" \
  --ignore-preflight-errors=Swap

# Setup kubeconfig
mkdir -p "$HOME"/.kube
echo "yes" | sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config

# Install Calico
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml

# Wait for API server
until kubectl get nodes; do
  echo "Waiting for API server..."
  sleep 5
done

# Generate join command
echo "#!/bin/bash" > /tmp/kubeadm_join_cmd.sh
kubeadm token create --print-join-command >> /tmp/kubeadm_join_cmd.sh
chmod +x /tmp/kubeadm_join_cmd.sh