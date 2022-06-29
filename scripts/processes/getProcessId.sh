#!/bin/bash

ORGANIZATION=$1

PROCESS_NAME=$2

PAT=$3

curl --silent --user :$PAT \
--request GET "https://dev.azure.com/$ORGANIZATION/_apis/process/processes?api-version=6.0" | jq -r '.value[] | select(.name=="'$PROCESS_NAME'") | .id'