#!/bin/bash

echo -n "Organization: " && read ORGANIZATION

echo -n "Project Name: " && read PROJECT_NAME

echo -n "PAT: " && read PAT

curl --silent --user :$PAT \
--request POST "https://dev.azure.com/$ORGANIZATION/_apis/projects?api-version=6.0" \
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "'"$PROJECT_NAME"'",
    "description": "Frabrikam travel app for Windows Phone",
    "visibility": "private",
    "capabilities": {
        "versioncontrol": {
            "sourceControlType": "Git"
        },
        "processTemplate": {
            "templateTypeId": "adcc42ab-9882-485e-a3ed-7678f01f66bc"
        }
    }
}' | jq -r .