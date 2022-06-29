#!/bin/bash

ORGANIZATION=$1

PROJECT_NAME=$2

PAT=$3

PROJECT_ID=$(curl --silent --user :$PAT \
--request GET "https://dev.azure.com/$ORGANIZATION/_apis/projects?api-version=6.0" | jq -r '.value[] | select(.name=="'$PROJECT_NAME'") | .id')

echo "$PROJECT_ID"