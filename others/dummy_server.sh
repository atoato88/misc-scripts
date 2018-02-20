#!/bin/bash

# create dummy http server
# https://qiita.com/yasuhiroki/items/d470829ab2e30ee6203f

PORT=${1:-8080}
RESPONSE_FILE_PATH="/tmp/dummy_server_response.txt"

cat <<EOF > ${RESPONSE_FILE_PATH}                                                                                                           
This is response.
EOF
while :
do 
  (echo -ne "HTTP/1.0 200 Ok\nContent-Length: $(wc -c < ${RESPONSE_FILE_PATH})\n\n"; cat ${RESPONSE_FILE_PATH}) | sudo nc -l -p ${PORT}
  date
done


