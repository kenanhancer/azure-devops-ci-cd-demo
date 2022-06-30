#!/bin/bash

echo -n "Organization: " && read ORGANIZATION

echo -n "Project Id or Project Name: " && read PROJECT_ID_NAME

echo -n "PAT: " && read PAT

curl --silent --user :$PAT \
--request GET "https://dev.azure.com/$ORGANIZATION/$PROJECT_ID_NAME/_apis/pipelines?api-version=7.1-preview.1" | jq -r .