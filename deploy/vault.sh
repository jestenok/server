helm install consul /code/k8s/consul \
    --namespace consul \
    --create-namespace \
    --values /code/k8s/consul/values.yaml

helm install vault /code/k8s/vault \
    --namespace vault \
    --create-namespace \
    --values /code/k8s/vault/values.yaml

kubectl -n vault exec -it vault-0 -- sh
kubectl -n vault exec -it vault-1 -- sh
kubectl -n vault exec -it vault-2 -- sh

vault operator init
vault operator unseal

kubectl -n vault exec -it vault-0 -- vault status
kubectl -n vault exec -it vault-1 -- vault status
kubectl -n vault exec -it vault-2 -- vault status

# --------------------------------------------------
#enable kubernetes auth
kubectl -n vault exec -it vault-0 -- sh

vault login
vault auth enable kubernetes

vault write auth/kubernetes/config \
    token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
    kubernetes_host=https://${KUBERNETES_PORT_443_TCP_ADDR}:443 \
    kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt \
    issuer="https://kubernetes.default.svc.cluster.local"

# --------------------------------------------------
#create a service account for the app
kubectl -n vault exec -it vault-0 -- sh

vault write auth/kubernetes/role/secret-access-role \
   bound_service_account_names=secret-access \
   bound_service_account_namespaces=flux-system,external-secrets \
   policies=secret-access-policy \
   ttl=1h

#create a policy for the app
cat <<EOF > /home/vault/app-policy.hcl
path "kv/*" {
  capabilities = ["read"]
}
EOF
vault policy write secret-access-policy /home/vault/app-policy.hcl

#create secrets
kubectl -n vault exec -it vault-0 -- sh
vault secrets enable -path=secret/ kv
vault kv put secret/basic-secret/helloworld username=dbuser password=supersecretpassword