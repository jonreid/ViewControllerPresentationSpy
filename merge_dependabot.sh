#!/bin/sh

gh pr merge --auto --rebase "$PR_URL"

if [ $? -ne 0 ]
then
    echo 'If you want GitHub to automatically merge pull requests from Dependabot, you need to create a'
    echo 'personal access token (public_repo) and assign it to Settings -> Secrets -> Dependabot -> GH_ACTION_TOKEN'
fi
