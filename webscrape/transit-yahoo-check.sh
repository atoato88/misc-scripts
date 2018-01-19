#!/bin/bash

# Reference
# https://stackoverflow.com/questions/2220301/how-to-evaluate-http-response-codes-from-bash-shell-script
# https://orebibou.com/2015/09/%E3%82%B7%E3%82%A7%E3%83%AB%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%97%E3%83%88%E3%81%A7%E3%80%81%E9%85%8D%E5%88%97%E5%86%85%E3%81%AE%E6%96%87%E5%AD%97%E5%88%97%E3%81%A8%E4%B8%80%E8%87%B4%E3%81%97%E3%81%AA/

# This script need ruby runtime to get urlencode string.

#set -e # If "set -e" is enabled, when xmllint return error code, script will exit. So comment out it.
set -u
#set -x

function urlencode() {
  ruby -r cgi -e "puts CGI.escape(\""$1"\")"
}

FROM=${FROM:-"東京"}
FROM=$(urlencode ${FROM})

TO=${TO:-"横浜"}
TO=$(urlencode ${TO})

URL="https://transit.yahoo.co.jp/search/result?from=${FROM}&to=${TO}&s=1&ticket=ic"

function is_http_error() {
  local error_code_array=(404 )
  local success_code_array=(200 )
  local code=$1

  if `echo ${success_code_array[@]} | grep -q "${code}"`
  then
    #echo 0
    return 0
  else
    #echo 1
    return 1
  fi
}

function check_result() {
  STR=${2:-""}
  if [[ ! $1 -gt 0 ]]
  then
    echo OK
    if [[ ! -z ${STR} ]]
    then
      echo $STR
    fi
    return 0
  else
    echo NG
    exit 1
  fi
}

# Check url response code.
RESPONSE_CODE=$(curl -L --write-out %{http_code} --silent --output /dev/null ${URL})
#echo ${RESPONSE_CODE}

is_http_error ${RESPONSE_CODE}
check_result $?

# Check target xpath. 
XPATH_EXP='//*[@id="route01"]//*[@class="print"]//a/@href'
RESPONSE="hoge $(curl -L --silent ${URL} | xmllint --html --xpath "${XPATH_EXP}" - 2>/dev/null)"
check_result $? "${RESPONSE}"

XPATH_EXP='//*[@class="labelSearchResult"]//*[@class="title"]/text()'
RESPONSE=$(curl -L --silent ${URL} | xmllint --html --xpath "${XPATH_EXP}" - 2>/dev/null)
check_result $? "${RESPONSE}"

XPATH_EXP='//*[@class="mark"]'
RESPONSE=$(curl -L --silent ${URL} | xmllint --html --xpath "${XPATH_EXP}" - 2>/dev/null)
check_result $? "${RESPONSE}"

# All check is OK. So return success code(0).
exit 0
