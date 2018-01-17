#!/bin/bash

# Reference
# https://stackoverflow.com/questions/2220301/how-to-evaluate-http-response-codes-from-bash-shell-script
# https://orebibou.com/2015/09/%E3%82%B7%E3%82%A7%E3%83%AB%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%97%E3%83%88%E3%81%A7%E3%80%81%E9%85%8D%E5%88%97%E5%86%85%E3%81%AE%E6%96%87%E5%AD%97%E5%88%97%E3%81%A8%E4%B8%80%E8%87%B4%E3%81%97%E3%81%AA/



set -eu
#set -x

FROM="%E6%96%B0%E6%9C%A8%E5%A0%B4"
TO="%E5%B8%82%E5%B7%9D"

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


# Check url response code.
RESPONSE_CODE=$(curl -L --write-out %{http_code} --silent --output /dev/null ${URL})
#echo ${RESPONSE_CODE}

is_http_error ${RESPONSE_CODE}

# Check target xpath. 
XPATH_EXP='//*[@id="route01"]'
RESPONSE=$(curl -L --silent ${URL} | xmllint --html --xpath "${XPATH_EXP}" - 2>/dev/null)
echo ${RESPONSE}


exit 0
