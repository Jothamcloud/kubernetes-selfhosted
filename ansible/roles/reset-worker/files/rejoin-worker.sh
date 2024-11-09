#!/bin/bash
set -euxo pipefail

# Reset kubeadm
echo "yes" | sudo kubeadm reset


# Execute join command
sudo bash /tmp/kubeadm_join_cmd.sh