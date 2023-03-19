helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add argo https://argoproj.github.io/argo-helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

helm install mysite /code/k8s/mysite \
    --namespace mysite \
    --create-namespace \
    --values /code/k8s/mysite/values.yaml