#!/bin/bash
## ref: https://qiita.com/R-STYLE/items/3127d82540688094c0ff

WORKD=/tmp/update-domain
DOMAIN=${1:-""}
PASSWD=${2:-""}

mkdir -p ${WORKD}

date +"%Y/%m/%d-%H:%M:%S %Z" > ${WORKD}/status
echo "Try to get external IP address: " >> ${WORKD}/status

/usr/bin/curl -s https://dyn.value-DOMAIN.com/cgi-bin/dyn.fcg?ip \
    -o ${WORKD}/current_ip                                      \
    -w '%{http_code}' >> ${WORKD}/status
# Just line feed.
echo "" >> ${WORKD}/status
grep -q 200 ${WORKD}/status

if [ $? -ne 0 ] ; then
  echo "ERROR: Fail to get external IP."
  echo "ERROR: Fail to get external IP." >> ${WORKD}/status
  exit 1
fi

prev=`cat ${WORKD}/prev_ip`
current=`cat ${WORKD}/current_ip`

if [ -z "$current" ] ; then
  echo "ERROR: GLOBAL IP REF ERROR"
  echo "ERROR: GLOBAL IP REF ERROR" >> ${WORKD}/status
  exit 1
fi

if [ "$prev" = "$current" ] ; then
  echo "OK: Current IP address is same with previous IP address, skip update." >> ${WORKD}/status
  exit 0
fi

cat ${WORKD}/current_ip > ${WORKD}/prev_ip

url="https://dyn.value-domain.com/cgi-bin/dyn.fcg?d=${DOMAIN}&p=${PASSWD}&h=*&i=${current}"

/usr/bin/curl -s "${url}" > ${WORKD}/curl.log.$$
grep -q "status=0" ${WORKD}/curl.log.$$

if [ $? -ne 0 ] ; then
  echo "ERROR: DDNS UPDATE ERROR"
  echo "ERROR: DDNS UPDATE ERROR" >> ${WORKD}/status
  exit 1
fi

echo "OK: Update IP address complete." >> ${WORKD}/status
rm ${WORKD}/curl.log.$$

exit 0

