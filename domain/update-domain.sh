#!/bin/bash
## ref: https://qiita.com/R-STYLE/items/3127d82540688094c0ff

WORKD=/tmp/update-domain
DOMAIN=${1:-""}
PASSWD=${2:-""}

mkdir -p ${WORKD}

/usr/bin/curl -s https://dyn.value-DOMAIN.com/cgi-bin/dyn.fcg?ip \
    -o ${WORKD}/current_ip                                      \
    -w '%{http_code}' > ${WORKD}/status

status=`cat ${WORKD}/status`
if [ "200" -ne "$status" ] ; then
  exit 0
fi

prev=`cat ${WORKD}/prev_ip`
current=`cat ${WORKD}/current_ip`

if [ -z "$current" ] ; then
  echo "GLOBAL IP REF ERROR"
  exit 0
fi

if [ "$prev" = "$current" ] ; then
  exit 0
fi

cat ${WORKD}/current_ip > ${WORKD}/prev_ip

url="https://dyn.value-DOMAIN.com/cgi-bin/dyn.fcg?d=${DOMAIN}&p=${PASSWD}&h=*&i=${current}"

/usr/bin/curl -s "${url}" > ${WORKD}/curl.log.$$

if [ $? -ne 0 ] ; then
  echo "DDNS UPDATE ERROR"
  exit 1
fi

rm ${WORKD}/curl.log.$$

exit 0
