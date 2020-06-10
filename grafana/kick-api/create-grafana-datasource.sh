#!/bin/bash

# create dashboard with api
echo '{
  "name": "Kubernetes-inou-dev03-<random>",
  "type": "prometheus",
  "typeLogoUrl": "",
  "access": "direct",
  "url": "http://localhost:8090",
  "password": "",
  "user": "",
  "database": "",
  "basicAuth": false,
  "basicAuthUser": "",
  "basicAuthPassword": "",
  "withCredentials": false,
  "isDefault": true,
  "jsonData": {},
  "secureJsonFields": {}
}
' | jq -c . | xargs -0 -I {} curl -u admin:admin -X POST -d {} -H "Content-Type: application/json" http://localhost:3000/api/datasources

# or use below.

#BEARER_TOKEN="TOKEN"
#
#echo '{
#  "name": "Kubernetes-inou-dev03-<random>",
#  "type": "prometheus",
#  "typeLogoUrl": "",
#  "access": "direct",
#  "url": "http://localhost:8090",
#  "password": "",
#  "user": "",
#  "database": "",
#  "basicAuth": false,
#  "basicAuthUser": "",
#  "basicAuthPassword": "",
#  "withCredentials": false,
#  "isDefault": true,
#  "jsonData": {},
#  "secureJsonFields": {}
#}
#' | jq -c . | xargs -0 -I {} curl -X POST -d {} -H "Authorization: Bearer ${BEARER_TOKEN}"  -H "Content-Type: application/json" http://localhost:3000/api/datasources
