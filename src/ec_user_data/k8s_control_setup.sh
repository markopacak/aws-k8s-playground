#! /bin/bash

exec &> /var/log/k8s_control_setup.log

export K8S_CLUSTER_TOKEN=${k8s_cluster_token}
export HOME=/home/ubuntu

set -o pipefail

INSTANCE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

hostnamectl set-hostname k8s-control

cat << EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sysctl --system

# containerd
sudo apt-get update && sudo apt-get install -y containerd
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
systemctl restart containerd

# swapoff
swapoff -a

apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update
apt-get install -y kubelet=1.24.0-00 kubeadm=1.24.0-00 kubectl=1.24.0-00
apt-mark hold kubelet kubeadm kubectl

kubeadm reset --force
kubeadm init --apiserver-advertise-address "$INSTANCE_IP" --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.25.5 --token "$K8S_CLUSTER_TOKEN"

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown ubuntu:ubuntu $HOME/.kube/config
chmod 0600 $HOME/.kube/config

# Get calico manifest
curl -o $HOME/calico.yaml https://docs.projectcalico.org/manifests/calico.yaml
kubectl apply -f $HOME/calico.yaml
