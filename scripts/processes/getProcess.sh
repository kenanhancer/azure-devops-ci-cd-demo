#!/bin/bash

echo -n "Organization: " && read ORGANIZATION

echo -n "Process Name: " && read PROCESS_NAME

echo -n "PAT: " && read PAT

PROCESS_ID=$(. ./getProcessId.sh $ORGANIZATION $PROCESS_NAME $PAT)

curl --silent --user :$PAT \
--request GET "https://dev.azure.com/$ORGANIZATION/_apis/process/processes/$PROCESS_ID?api-version=6.0" | jq -r .