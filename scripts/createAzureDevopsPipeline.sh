#!/bin/bash

echo -n "Organization: " && read ORGANIZATION

echo -n "Project Name: " && read PROJECT_NAME

echo -n "Pipeline Name: " && read PIPELINE_NAME

echo -n "PAT: " && read PAT

curl --silent --user :$PAT \
--request POST "https://dev.azure.com/$ORGANIZATION/$PROJECT_NAME/_apis/pipelines?api-version=6.1-preview.1" \
--header 'Content-Type: application/json' \
--data-raw '{
    "folder": null,
    "name": "'"$PIPELINE_NAME"'",
    "configuration": {
        "type": "yaml",
        "path": "/azure-pipelines.yml",
        "repository": {
            "id": "941eabc5-25f0-4151-a657-dfb5de7c5c2d",
            "name": "Kenanhancer-github",
            "type": "azureReposGit"
        }
    }
}' | jq -r .