#cloud-config
# vim: syntax=yaml

package_upgrade: true

write_files:
  - path: /etc/systemd/system/docker.service.d/10-storage-driver.conf
    owner: root:root
    permissions: 0644
    content: |
      [Service]
      ExecStart=
      ExecStart=/usr/bin/dockerd -H fd:// --storage-driver=overlay
  - path: /etc/kubernetes/kubeadm.conf
    owner: root:root
    permissions: 0644
    content: |
      apiVersion: kubeadm.k8s.io/v1alpha1
      kind: MasterConfiguration
      networking:
        podSubnet: 192.168.0.0/16
      cloudProvider: aws
      token: ee99fa.4fd6d8638c0e21bd
      apiServerExtraArgs:
        admission-control: NamespaceAutoProvision,Initializers,NamespaceLifecycle,LimitRanger,ServiceAccount,PersistentVolumeLabel,DefaultStorageClass,DefaultTolerationSeconds,NodeRestriction,ResourceQuota
      apiServerCertSANs: [${elb_dnsname}]


packages:
  - build-essential
  - curl
  - gnupg2
  - htop
  - git-core
  - apt-transport-https
  - ca-certificates
  - vim-nox
  - tmux
  - rsync
  - keychain
  - awscli

runcmd:
  - apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys 0xF76221572C52609D 0x3746C208A7317B0F
  - echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list
  - echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
  - apt-get update && apt-get install -y docker-engine kubelet kubeadm kubectl kubernetes-cni
  - systemctl daemon-reload
  - systemctl enable docker
  - systemctl enable kubelet
  - systemctl start docker
  - echo 127.0.0.1 $(curl 169.254.169.254/latest/meta-data/hostname) | sudo tee -a /etc/hosts
  - curl 169.254.169.254/latest/meta-data/hostname | sudo tee /etc/hostname
  - sudo hostname $(curl 169.254.169.254/latest/meta-data/hostname)
  - kubeadm init --config /etc/kubernetes/kubeadm.conf
  - mkdir -p $HOME/.kube
  - sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  - sudo chown $(id -u):$(id -g) $HOME/.kube/config
  - kubectl apply -f https://docs.projectcalico.org/v2.6/getting-started/kubernetes/installation/hosted/kubeadm/1.6/calico.yaml

output: { all : '| tee -a /var/log/cloud-init-output.log' }

final_message: "The system is finally up, after $UPTIME seconds"

# kubeadm init --token=${k8s_token} --cloud-provider=aws
# needs https://github.com/kubernetes/kubernetes/pull/33681

# original init line  - 
# kubeadm init --token=${k8s_token} --pod-network-cidr=192.168.0.0/16 --apiserver-cert-extra-sans=${elb_dnsname}
# config file init line - 
# kubeadm init --config /etc/kubernetes/kubeadm.conf