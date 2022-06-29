#!/bin/bash

echo -n "Organization: " && read ORGANIZATION

echo -n "PAT: " && read PAT

curl --silent --user :$PAT \
--request GET "https://dev.azure.com/$ORGANIZATION/_apis/projects?api-version=6.0" | jq -r .