curl -s https://fluxcd.io/install.sh | sudo bash

export GITHUB_TOKEN=<your-token>
export GITHUB_USER=<your-username>

flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=server \
  --branch=master \
  --path=./cluster \
  --personal