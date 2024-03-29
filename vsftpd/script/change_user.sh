#!/bin/bash

username=$1
userid=$2
groupid=$3

# add group
if ! getent group "$groupid" >/dev/null; then
    groupadd -g "$groupid" "g$groupid"
fi

if ! getent passwd "$username" >/dev/null; then
    echo "user '$username' not exists." >&2
    exit 1
fi

usermod -u "$userid" -g "$groupid" "$username"
