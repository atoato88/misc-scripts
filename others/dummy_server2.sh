#!/bin/bash

# create dummy http server
# ref: https://qiita.com/yasuhiroki/items/d470829ab2e30ee6203f

PORT=${1:-8080}
RESPONSE=${2:-"This is response."}
RESPONSE_FILE_PATH="/tmp/dummy_server_response.txt"

function create_response(){
  COUNT=$(date +%s)
  cat <<EOF > ${RESPONSE_FILE_PATH}
  dummy_counter1{label1="val1", label2="val2"} ${COUNT}
EOF
}

echo Server start at localhost:${PORT}

while :
do
  create_response
  (echo -ne "HTTP/1.0 200 Ok\nContent-Length: $(wc -c < ${RESPONSE_FILE_PATH})\n\n"; cat ${RESPONSE_FILE_PATH}) | sudo nc -l -p ${PORT}
  echo sent response at : $(date)
done


