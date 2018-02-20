#!/bin/bash

INPUT=${1}

cat ${INPUT} | jq -cM ".dashboard.rows[].panels[] | {title:.title, expr:.targets[].expr}"
