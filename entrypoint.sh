#!/bin/bash

mkdir /root/.ssh
echo "$PRIVATE_KEY" >/root/.ssh/id_rsa # works even if key is not rsa kind
chmod 0600 /root/.ssh/id_rsa

# wget -O /usr/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
# chmod +x /usr/bin/cloudflared

echo "Host cfhost" >>/root/.ssh/config
echo "    HostName ${HOST}"
echo "    ProxyCommand /usr/bin/cloudflared access ssh --hostname %h --service-token-id '${ID}' --secret '${TOKEN}'" >>/root/.ssh/config

if [ -z "${HOST_FINGERPRINT}" ]; then
  echo ">> No public ssh fingerprint found, man-in-the-middle protection disabled!"
  ssh-keyscan -H -p ${PORT} cfhost >/root/.ssh/known_hosts
else
  echo ">> Public ssh fingerprint found, man-in-the-middle protection enabled."
  echo "${HOST_FINGERPRINT}" >/root/.ssh/known_hosts
fi

# Execute the command
ssh -o StrictHostKeyChecking=no -o PubkeyAcceptedKeyTypes=+ssh-rsa -o HostKeyAlgorithms=+ssh-rsa "${USER}@cfhost" -p ${PORT} ${COMMAND}
