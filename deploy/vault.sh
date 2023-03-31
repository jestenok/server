kubectl -n vault exec -it vault-0 -- sh

vault operator init
vault operator unseal

kubectl -n vault exec -it vault-0 -- vault status

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
path "kv/*"          { capabilities = ["read"]}

path "pki*"          { capabilities = ["read", "list"] }
path "pki/sign/*"    { capabilities = ["create", "update"] }
path "pki/issue/*"   { capabilities = ["create"] }
EOF

vault policy write secret-access-policy /home/vault/app-policy.hcl

#create secrets
kubectl -n vault exec -it vault-0 -- sh
vault secrets enable -path=secret/ kv
vault kv put secret/basic-secret/helloworld username=dbuser password=supersecretpassword
# --------------------------------------------------
#add cert manager
vault secrets enable pki
vault secrets tune -max-lease-ttl=8760h pki

vault write pki/root/generate/internal \
    common_name=jestenok.com \
    ttl=8760h

vault write pki/config/urls \
    issuing_certificates="http://vault.vault:8200/v1/pki/ca" \
    crl_distribution_points="http://vault.vault:8200/v1/pki/crl"

vault write pki/roles/jestenok-dot-com \
    allowed_domains=jestenok.com \
    allow_subdomains=true \
    max_ttl=72h

vault policy write pki - <<EOF
path "pki*"                        { capabilities = ["read", "list"] }
path "pki/sign/jestenok-dot-com"    { capabilities = ["create", "update"] }
path "pki/issue/jestenok-dot-com"   { capabilities = ["create"] }
EOF

#    jira.jestenok.com,grafana.jestenok.com,vault.jestenok.com,\
#    jenkins.jestenok.com,elasticsearch.jestenok.com \