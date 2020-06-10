#!/bin/bash
#Kubernetes master node setup process -->>

echo "Kubernetes installation process..."

setenforce  0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/'  /etc/selinux/config
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
swapoff  -a

sleep 3
#Create the repo from online repository for k8s
cat  <<EOF  >/etc/yum.repos.d/kube.repo
[kube]
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
gpgcheck=0
EOF

sleep 2
#Installing docker and kubeadm 
yum  install  docker kubeadm  -y
systemctl enable --now  docker kubelet

sleep 3
#Establishing network for online cloud provider like GCP, Azure, AWS, Digital Ocean
kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=0.0.0.0   --apiserver-cert-extra-sans=publicip,privateip,serviceip

sleep 10
#To make a client of k8s
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

#Calico installation
kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml

sleep 10
#active nodes
kubectl get nodes
sleep 2

echo "Master cluster successfully done!!"


