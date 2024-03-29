#!/bin/bash

function init_tenant() {
    tenant=$1
    tenantPath=$2

    groupid=$(ls -ln "$tenantPath" | grep "public" | awk '{print $4}')
    if ! getent group "$groupid" >/dev/null; then
        groupadd -g "$groupid" "g$groupid"
    fi

    # init tenant public
    useradd -u 0 -g "$groupid" -d "$tenantath"/public -o public_"$tenant"

    ls -ln "$tenantPath"/user | grep "^d" | awk '{print $9, $3, $4}' >tmp_users.txt

    while read username userid groupid; do
        if [ x"$userid" == x"0" ] && [ x"$username" != x"root" ] && [ x"$username" != x"public" ]; then
            echo "invalid user '$username'-'$userid'-'$groupid'" >&2
            continue
        fi

        if ! getent group "$groupid" >/dev/null; then
            groupadd -g "$groupid" "g$groupid"
        fi

        if ! getent passwd "$username" >/dev/null; then
            useradd -u "$userid" -g "$groupid" -d "$tenantPath/user/$username" "$username"
        fi
    done <tmp_users.txt

    rm tmp_users.txt
}

if [ ! -d "/tenant" ] || [ ! "$(ls -A /tenant)" ]; then
    echo "directory /tenant does not exist or does not contain subdirectories"
    exit 0
fi

for tenant in $(ls -A /tenant); do
    tenantPath=/tenant/$tenant
    # shellcheck disable=sC2086
    init_tenant "$tenant" $tenantPath
done
