FROM jenkins/jenkins:2.426.2-lts-jdk17

LABEL maintainer="Dylan Dong"

USER root

RUN apt update && apt install -y lsb-release && \
    curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc https://download.docker.com/linux/debian/gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.asc] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt update && apt install -y docker-ce-cli && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    