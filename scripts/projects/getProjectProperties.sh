#!/bin/bash

echo -n "Organization: " && read ORGANIZATION

echo -n "Project Name: " && read PROJECT_NAME

echo -n "PAT: " && read PAT

PROJECT_ID=$(. ./getProjectId.sh $ORGANIZATION $PROJECT_NAME $PAT)

curl --silent --user :$PAT \
--request GET "https://dev.azure.com/$ORGANIZATION/_apis/projects/$PROJECT_ID/properties?api-version=6.0-preview.1" | jq -r .