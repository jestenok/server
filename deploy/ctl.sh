#installing kube-seal
curl -L -o /tmp/kubeseal.tar.gz \
https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.19.1/kubeseal-0.19.1-linux-amd64.tar.gz
tar -xzf /tmp/kubeseal.tar.gz -C /tmp/
chmod +x /tmp/kubeseal
mv /tmp/kubeseal /usr/local/bin/

#getting the public key
kubeseal --fetch-cert --controller-name=sealed-secrets --controller-namespace=kube-system