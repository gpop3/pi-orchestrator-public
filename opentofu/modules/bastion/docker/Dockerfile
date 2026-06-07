FROM debian:12-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      openssh-server \
      libpam-google-authenticator \
      ca-certificates \
      curl \
 && rm -rf /var/lib/apt/lists/* \
 && useradd -m -s /bin/bash jump \
 && mkdir -p /home/jump/.ssh /var/run/sshd \
 && chown -R jump:jump /home/jump/.ssh \
 && chmod 700 /home/jump/.ssh

COPY sshd_config        /etc/ssh/sshd_config
COPY pam_sshd           /etc/pam.d/sshd
COPY entrypoint.sh      /usr/local/bin/entrypoint.sh
COPY sshrc              /etc/ssh/sshrc

RUN chmod 0755 /usr/local/bin/entrypoint.sh /etc/ssh/sshrc

EXPOSE 22
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
