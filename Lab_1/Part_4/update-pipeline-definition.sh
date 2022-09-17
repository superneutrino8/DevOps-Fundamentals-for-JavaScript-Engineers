#!/bin/bash

# configuration
defaultPipeline="pipeline"
customPipelineChoice="custom"

# colors
red=$'\e[1;31m'
green=$'\e[1;32m'
end=$'\e[0m'

# check if JQ is installed
checkJQ() {
    # jq test
    type jq >/dev/null 2>&1
    exitCode=$?

    # track jq dependency
    jqDependency=1

    if [ "$exitCode" -ne 0 ]; then
        printf "${red}'jq' not found! (json parser)\n${end}"
        printf "Installation: sudo apt install jq\n"
        jqDependency=0
    fi

    if [ "$jqDependency" -eq 0 ]; then
        printf "${red}Missing 'jq' dependency, exiting.\n${end}"
        exit 1
    fi
}

# perform checks
checkJQ

# take pipelineName from user
echo -n "Enter a CodePipeline name (or $customPipelineChoice)(default: $defaultPipeline): "
read -r pipelineName
pipelineName=${pipelineName:-$defaultPipeline}

# check if pipelineName and customPipelineChoice are same
if [ "$pipelineName" = "$customPipelineChoice" ]; then
    echo -n "Enter a CodePipeline name: "
    read -r pipelineName
fi

# set default branch name
defaultBranchName="develop"

# take branchName from user
echo -n "Enter a source branch to use (default: $defaultBranchName): "
read -r branchName
branchName=${branchName:-$defaultBranchName}

pipelineJson="pipeline.json"

# upd source branch
jq --arg branchName "$branchName" '.pipeline.stages[0].actions[0].configuration.BranchName = $branchName' "$pipelineJson" >tmp.$$.json && mv tmp.$$.json "$pipelineJson"

# remove metadata
jq 'del(.metadata)' "$pipelineJson" >tmp.$$.json && mv tmp.$$.json "$pipelineJson"

# increment version no.
jq '.pipeline["version"] += 1' "$pipelineJson" >tmp.$$.json
cp tmp.$$.json "$pipelineJson"

exit 0
