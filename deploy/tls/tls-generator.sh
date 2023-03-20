#install cfssl
curl -L https://github.com/cloudflare/cfssl/releases/download/v1.6.1/cfssl_1.6.1_linux_amd64 -o /usr/local/bin/cfssl && \
curl -L https://github.com/cloudflare/cfssl/releases/download/v1.6.1/cfssljson_1.6.1_linux_amd64 -o /usr/local/bin/cfssljson && \
chmod +x /usr/local/bin/cfssl && \
chmod +x /usr/local/bin/cfssljson

#generate ca in /tmp
cfssl gencert -initca ca-csr.json | cfssljson -bare /tmp/ca

#generate certificate in /tmp
cfssl gencert \
  -ca=/tmp/ca.pem \
  -ca-key=/tmp/ca-key.pem \
  -config=ca-config.json \
  -hostname="vault,vault.vault.svc.cluster.local,vault.vault.svc,localhost,127.0.0.1,jestenok.com" \
  -profile=default \
  ca-csr.json | cfssljson -bare /tmp/vault

#creating secrets
kubectl -n consul create secret tls tls-ca \
 --cert deploy/tls/certs/ca.pem  \
 --key deploy/tls/certs/ca-key.pem

kubectl -n consul create secret tls tls-server \
  --cert deploy/tls/certs/vault.pem \
  --key deploy/tls/certs/vault-key.pem