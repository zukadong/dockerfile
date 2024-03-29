FROM ubuntu:jammy

LABEL maintainer="Zuka Dong"

RUN apt update \
    && apt install -y vsftpd libpam-pwdfile apache2-utils \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /etc/vsftpd && \
    mkdir -p /app/script && \
    mkdir -p /var/run/vsftpd/empty

# copy static files
COPY ./static/chroot_list \
    ./static/user_list \
    ./static/vsftpd.conf \
    /etc/vsftpd/

# copy pam file
COPY ./static/vsftpd /etc/pam.d/

# copy shell scripts
COPY ./script/* /app/script/

# copy runtime file
COPY ./run/* /app/

ENTRYPOINT ["/bin/bash", "/app/startup.sh"]
