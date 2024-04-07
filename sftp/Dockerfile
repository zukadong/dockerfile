FROM ubuntu:jammy

LABEL maintainer="Zuka Dong"

# openssh-server: provide sftp server
# libpam-pwdfile: pam pwdfile.so module
# whois:          mkpasswd command, to generate yescrypt password
# apache2-utils:  htpasswd command, to manage user password
RUN apt update && \
    apt install -y openssh-server libpam-pwdfile whois apache2-utils language-pack-zh-hans && \
    locale-gen zh_CN.UTF-8 && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LANG zh CN.UTF-8

RUN mkdir -p /app/script && \
    echo "Asia/shanghai">/etc/timezone

# copy sshd config
COPY ./config/sshd_config /etc/ssh/sshd_config

# copy pam module
COPY ./config/sshd /etc/pam.d/sshd

# copy shell scripts
COPY ./script/* /app/script/

# copy runtime file
COPY ./run/* /app/

ENTRYPOINT ["/bin/bash", "/app/startup.sh"]
