curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable=traefik" sh -
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config