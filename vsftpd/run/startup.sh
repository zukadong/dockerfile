#!/bin/bash

chmod u+x /app/startup.sh && chmod u+x /app/server && chmod u+x /app/script/*.sh

/app/script/init_users.sh

/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf &

/app/server
