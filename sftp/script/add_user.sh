#!/bin/bash

username=$1
userid=$2
groupid=$3
password=$4

# set home path
if [ x"$username" == x"public" ]; then
    homepath="/data/public"
else
    homepath="/data/user/$username"
fi

# add group
if ! getent group "$groupid" >/dev/null; then
    groupadd -g "$groupid" "g$groupid"
fi

# check user if exist
if getent passwd "$username" >/dev/null; then
    uid=$(id -u "$username")
    gid=$(id -g "$username")

    if [ x"$uid" == x"$userid"] && [ x"$gid"== x"$groupid" ]; then
        echo "user '$username' already exists."
    else
        echo "user '$username' already exists, but uid or gid not match, will delete old user."

        if [ x"$username"== x"root"] || [ x"$username" == x"public" ]; then
            echo "user '$username' cannot be deleted." >&2
            exit 1
        fi

        /app/script/delete_user.sh "$username"
    fi
fi

# add user
if ! getent passwd "$username" >/dev/null; then
    useradd -u "$userid" -g "$groupid" -d "$homepath" "$username"
fi

# add user pam
htpasswd -p -b /data/sftp/userlist "$username" $(mkpasswd --method=yescrypt "$password")
