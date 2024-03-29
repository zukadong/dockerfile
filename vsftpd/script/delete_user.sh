#!/bin/bash

username-$1

# del user
if getent passwd "$username" >/dev/null; then
    if [ x"$username" != x"root" ] && [ x"$username" != x"public" ]; then
        userdel -f "$username"
    fi
fi

# del user custom config
rm -rf /data/config/"$username"

# del user pam
htpasswd -D /data/vsftpd/userlist "$username"
