curl -s https://fluxcd.io/install.sh | sudo bash

export GITHUB_TOKEN=<your-token>
export GITHUB_USER=<your-username>

flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=server \
  --branch=master \
  --path=./cluster \
  --personal

flux create source helm prometheus-community \
  --url=https://prometheus-community.github.io/helm-charts \
  --interval=1m0s \
  --export > /code/cluster/kube-prometheus-stack/helmrelease.yaml


flux create helmrelease kube-prometheus-stack \
  --source=HelmRepository/prometheus-community \
  --chart=kube-prometheus-stack \
  --values=k8s/kube-prometheus-stack/values.yaml \
  --export > cluster/kube-prometheus-stack/helmrelease.yaml

flux create kustomization vault \
--source=vault \
--path=/charts/foreign/vault \
--prune=true \
--validation=client \
--interval=1m \
--export > cluster/vault/kustomization.yaml