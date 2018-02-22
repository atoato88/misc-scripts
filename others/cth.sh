#!/bin/bash

# "cth" is abbreviation for "cut through"

# example is below.
#
# $ kubectl get pods -n gitlab
# NAME                                  READY     STATUS    RESTARTS   AGE
# git0-docker-gitlab-548d75d546-57bbj   1/1       Running   0          21m
# git0-postgresql-6f4885b8df-mx2lx      1/1       Running   0          15d
# git0-redis-b6cc7c49f-qcxqk            1/1       Running   0          15d
#
# $ kubectl get pods -n gitlab | cth
# git0-docker-gitlab-548d75d546-57bbj
#
# $ kubectl get pods -n gitlab | cth 2 5
# 21m


ROW=${1:-"2"}
COL=${2:-"1"}

cat - | head -n${ROW} | tail -n1 | awk "{print \$${COL}}"

