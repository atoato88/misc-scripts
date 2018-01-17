#!/bin/bash

# Original script is https://gist.github.com/kizbitz/175be06d0fbbb39bc9bfa6c0cb0d4721 

# Example for the Docker Hub V2 API
# Returns all images and tags associated with a Docker Hub organization account.
# Requires 'jq': https://stedolan.github.io/jq/

# set username, password, and organization
UNAME=$UNAME
UPASS=$UPASS
ORG=$ORG
PAGE_SIZE=${PAGE_SIZE:-100}

function show_images() {
  page=$1
  page_size=$2
	REPO_LIST=$(curl -s -H "Authorization: JWT ${TOKEN}" https://hub.docker.com/v2/repositories/${ORG}/?page=$page\&page_size=$page_size | jq -r '.results|.[]|.name')
	for i in ${REPO_LIST}
	do
		echo "${i}"
		# tags
		#IMAGE_TAGS=$(curl -s -H "Authorization: JWT ${TOKEN}" https://hub.docker.com/v2/repositories/${ORG}/${i}/tags/?page_size=100 | jq -r '.results|.[]|.name')
		#for j in ${IMAGE_TAGS}
		#do
		#  echo "  - ${j}"
		#done
		#echo
	done
}

# -------

set -e
#echo

# get token
#echo "Retrieving token ..."
TOKEN=$(curl -s -H "Content-Type: application/json" -X POST -d '{"username": "'${UNAME}'", "password": "'${UPASS}'"}' https://hub.docker.com/v2/users/login/ | jq -r .token)
#echo token $TOKEN

IMAGE_COUNT=$(curl -s -H "Authorization: JWT ${TOKEN}" https://hub.docker.com/v2/repositories/${ORG}/? | jq -r .count)
#echo image count $IMAGE_COUNT

LOOP_COUNT=$(expr $IMAGE_COUNT / $PAGE_SIZE)
#echo loop count $LOOP_COUNT

if $(expr $IMAGE_COUNT % $PAGE_SIZE > /dev/null)
then
  LOOP_COUNT=$(expr $LOOP_COUNT + 1)
fi

# get list of repositories
#echo "Retrieving repository list ..."

for i in $(seq $LOOP_COUNT)
do
  #echo loop $i/$LOOP_COUNT
  show_images $i $PAGE_SIZE
done

