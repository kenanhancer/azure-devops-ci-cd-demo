#!/bin/bash

echo -n "Organization: "
read ORGANIZATION

echo -n "Project: "
read PROJECT

echo -n "PAT: "
read PAT

curl -s -u :$PAT \
"https://dev.azure.com/$ORGANIZATION/_apis/projects?api-version=6.0" | jq .