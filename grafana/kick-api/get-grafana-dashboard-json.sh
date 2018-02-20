#!/bin/bash

NAME=${1:-"prometheus-inou-dev03"}
BEARER="TOKEN"

curl -H "Authorization: Bearer ${BEARER}" http://localhost:3000/api/dashboards/db/${NAME} | jq

