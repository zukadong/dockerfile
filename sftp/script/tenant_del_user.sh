#!/bin/bash

username=$1

# del user
if getent passwd "$username" >/dev/null; then
    uid=$(id -u"$username")
    # not admin user, use userdel
    if [ x"$uid" != x"0" ]; then
        userdel -f "$username"
    else
        sed -i "/^${1}:/d" /etc/subgid
        sed -i "/^${1}:/d" /etc/subuid
        sed -i "/^${1}:/d" /etc/passwd
        sed -i "/^${1}:/d" /etc/shadow
        sed -i "/^${1}:/d" /etc/gshadow
    fi
fi

# del user pam
htpasswd -D /data/sftp/userlist "$username"

# del user custom config
rm -rf /data/sftp/config/"$username"

# reload ssh
service ssh reload
