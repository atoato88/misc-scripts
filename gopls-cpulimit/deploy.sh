#!/bin/bash

CURRENT=$(cd $(dirname $0);pwd)
SCRIPT="gopls-cpulimit.sh"
SERVICE="gopls-cpulimit.service"

sudo cp ${SCRIPT} /usr/local/bin/
sudo cp ${SERVICE} /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable ${SERVICE}

echo "install complete"
