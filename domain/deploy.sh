#!/bin/bash

CURRENT=$(cd $(dirname $0);pwd)
SCRIPT="update-domain.sh"
SERVICE="update-domain.service"
TIMER="update-domain.timer"

sudo cp ${SCRIPT} /usr/local/bin/
sudo cp ${SERVICE} /etc/systemd/system/
sudo cp ${TIMER} /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable update-domain.timer
sudo systemctl start update-domain.timer

echo "In advance, you have to set \"a * <current global ip>\" at DNS setting on value-domain page."
