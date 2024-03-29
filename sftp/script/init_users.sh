#!/bin/bash

# custom config dir
mkdir -p /data/sftp/config

# if user list not exist, create it
if [ ! -f /data/sftp/userlist ]; then
    touch /data/sftp/userlist
    chmod 640 /data/sftp/userlist
fi

# init public
useradd -u 0 -g 0 -d /data/public -o public

# init user
ls -ln /data/user | grep "^d" | awk '{print $9, $3, $4}' >tmp_users.txt

while read username userid groupid; do
    if [ x"$userid" == x"0" ] && [ x"$username" != x"root" ] && [ x"$username" != x"public" ]; then
        echo "invalid user '$username'-'$userid'-'$groupid'." >&2
        continue
    fi

    if ! getent group "$groupid" >/dev/null; then
        groupadd -g "$groupid" "g$groupid"
    fi

    if ! getent passwd "$username" >/dev/null; then
        useradd -u "$userid" -g "$groupid" -d "/data/user/$username" "$username"
    fi
done <tmp_users.txt

rm tmp_users.txt
