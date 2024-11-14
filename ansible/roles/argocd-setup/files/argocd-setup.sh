#!/bin/bash

# Create ArgoCD namespace
kubectl create namespace argocd

# Install ArgoCD server
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.12.7/manifests/install.yaml

# Install ArgoCD CLI
wget -O argocd https://github.com/argoproj/argo-cd/releases/download/v2.13.0/argocd-linux-amd64

mv argocd 

chmod +x argocd

sudo mv argocd /usr/local/bin/

