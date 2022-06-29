#!/bin/bash

curl --user :65qyvduqy5smbo4svkeh6j6fr22qbf4wwgzjmwtmayia7mwoarra --header "Content-Type: application/json" --header "Accept:application/json" "https://dev.azure.com/kenanhancer/sandbox/_apis/pipelines?api-version=6.1-preview.1" -d @makepipeline.json