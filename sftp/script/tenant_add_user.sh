#!/bin/bash

username=$1
userid=$2
groupid=$3
password=$4
tenant=$5

# set home path
if [[ x"$username" == xpublic_* ]]; then
    homepath="/tenant/$tenant/public"
    chrotdir="/tenant/$tenant/public"
else
    homepath="/tenant/$tenant/user/$username"
    chrotdir="/tenant/$tenant/user"
fi

# add group
if ! getent group "$groupid" >/dev/null; then
    groupadd -g "$groupid" "g$groupid"
fi

# check user exist
if getent passwd "$username" >/dev/null; then
    uid=$(getent passwd "$username" | awk -F: '{print $3}')
    gid=$(getent passwd "$username" | awk -F: '{print $4}')
    if [ x"$uid" == x"$userid" ] && [ x"$gid" == x"$groupid" ]; then
        echo "user '$username' already exists."
    else
        echo "user '$username' already exists, but uid or gid not match, will delete old user"

        /app/script/tenant_del_users.sh "$username"
    fi
fi

# add user config
touch /data/sftp/config/"$username"

# add user
if [[ x"$username" == xpublic_* ]]; then
    if ! getent passwd "$username" >/dev/null; then
        useradd -u "$userid" -g "$groupid" -d "$homepath" -o "$username"
    fi

    echo -e "Match User $username\nForceCommand internal-sftp -f AUTH -l INFO\nChrootDirectory $chrotdir" >/data/sftp/config/"$username"
else
    if ! getent passwd "$username" >/dev/null; then
        useradd -u "$userid" -g "$groupid" -d "$homepath" "$username"
    fi

    echo -e "Match User $username\nForceCommand internal-sftp -f AUTH -l INFO -d /%u\nChrootDirectory $chrotdir" >/data/sftp/config/"$username"
fi

# add user password
htpasswd -p -b /data/sftp/userlist "$username" $(mkpasswd --method=yescrypt "$password")

# reload ssh
service ssh reload
