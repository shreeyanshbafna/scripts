#!/bin/bash
#Kubernetes worker node setup process -->>

echo -e "Process is loading... "

setenforce  0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/'  /etc/selinux/config
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
swapoff  -a

sleep 3
#create the repo from online repository for k8s
cat  <<EOF  >/etc/yum.repos.d/kube.repo
[kube]
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
gpgcheck=0
EOF

sleep 2
#installing docker and kubeadm

yum  install  docker kubeadm  -y
systemctl enable --now  docker kubelet

sleep 1
echo "Installation Successfully done!!"


