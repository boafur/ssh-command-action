FROM alpine:3.21

RUN apk add --no-cache openssh bash wget

RUN sed -i -e "s/Host \*/&\n    KexAlgorithms curve25519-sha256,ecdh-sha2-nistp521,kex-strict-c-v00@openssh.com/g" /etc/ssh/ssh_config

RUN wget -O /usr/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
RUN chmod +x /usr/bin/cloudflared

# Copies the entrypoint.sh file from the repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Make the bash script executable
RUN chmod +x /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
