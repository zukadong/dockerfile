#!/bin/bash

chmod u+x /app/startup.sh && chmod u+x /app/server && chmod u+x /app/script/*.sh

/app/script/tenant_init_users.sh

/app/script/init_users.sh

service ssh start -e

/app/server
