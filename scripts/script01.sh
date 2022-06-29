#!/bin/bash


## Define variables

USER=$(az account show | jq -r .user.name)
ORGANIZATION="<EXISTING_AZURE_DEVOPS_ORGANIZATION_NAME>"
PROJECT="<NEW_AZURE_DEVOPS_PROJECT_NAME>"
PAT='<PERSONAL_ACCESS_TOKEN>'
 
## Test if authentication working (List projects in your organization)
curl -s -u $USER:$PAT \
https://dev.azure.com/$ORGANIZATION/_apis/projects?api-version=6.0 | jq .



## Create a new Azure DevOps project
curl -s --request POST \
-u $USER:$PAT \
--header "Content-Type: application/json" \
--data '{
  "name": "'"$PROJECT"'",
  "description": "Demo Project For Azure Pipeline",
  "capabilities": {
    "versioncontrol": {
      "sourceControlType": "Git"
    },
    "processTemplate": {
      "templateTypeId": "6b724908-ef14-45cf-84f8-768b5384da45"
    }
  }
}' \
https://dev.azure.com/$ORGANIZATION/_apis/projects?api-version=6.0 | jq .



## Get project default repository details
REPOSITORY_ID=$(curl -s -u $USER:$PAT \
https://dev.azure.com/$ORGANIZATION/$PROJECT/_apis/git/repositories?api-version=6.0 | jq -r .value[0].id) &&
curl -s -u $USER:$PAT \
https://dev.azure.com/$ORGANIZATION/$PROJECT/_apis/git/repositories/$REPOSITORY_ID?api-version=6.0 | jq .
 
## Clone project default repository
REPO_HTTPS_CLONE_URL=$(curl -s -u $USER:$PAT \
https://dev.azure.com/$ORGANIZATION/$PROJECT/_apis/git/repositories?api-version=6.0 | jq -r .value[0].webUrl
) &&
B64_PAT=$(printf "%s"":$PAT" | base64) &&
git -c http.extraHeader="Authorization: Basic ${B64_PAT}" \
clone $REPO_HTTPS_CLONE_URL


## Create your pipline definition
cd $PROJECT

cat <<EOF> azure-pipelines.yml
pool: mypool #or u can use a microsoft-hosted agent
trigger:
  branches:
    include:
    - '*'
stages:
- stage: Build
  jobs:
  - job: BuildJob
    steps:
    - script: echo Building!
- stage: Test
  jobs:
  - job: TestOnWindows
    steps:
    - script: echo Testing on Windows!
  - job: TestOnLinux
    steps:
    - script: echo Testing on Linux!
- stage: Deploy
  jobs:
  - job: Deploy
    steps:
    - script: echo Deploying the code!
EOF

## Push the changes to Azure Repo
git add azure-pipelines.yml
git commit -m "azure-pipelines.yml added"
git -c http.extraHeader="Authorization: Basic ${B64_PAT}" push




## Create a new Azure Pipeline using REST API
curl -s --request POST \
-u $USER:$PAT \
--header "Content-Type: application/json" \
--data '{
  "folder": null,
  "name": "mypipeline",
  "configuration": {
    "type": "yaml",
    "path": "/azure-pipelines.yml",
    "repository": {
      "id": "'"$REPOSITORY_ID"'",
      "name": "'"$PROJECT"'",
      "type": "azureReposGit"
    }
  }
}' \
https://dev.azure.com/$ORGANIZATION/$PROJECT/_apis/pipelines?api-version=6.0-preview.1 | jq .

## Get Azure Pipeline details
PIPELINE_ID=$(curl -s -u $USER:$PAT \
https://dev.azure.com/$ORGANIZATION/$PROJECT/_apis/pipelines?api-version=6.0-preview.1 | jq .value[0].id) &&
curl -s -u $USER:$PAT \
https://dev.azure.com/$ORGANIZATION/$PROJECT/_apis/pipelines/$PIPELINE_ID?api-version=6.0-preview.1 | jq .