#!/bin/bash

GH_OWNER=$GH_OWNER
GH_REPOSITORY=$GH_REPOSITORY
GH_TOKEN=$GH_TOKEN
GH_RUNNER_LABELS=$GH_RUNNER_LABELS


if [[ -z "${RUNNER_NAME}" ]]; then
    RUNNER_SUFFIX=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 5 | head -n 1)
    RUNNER_NAME="dockerNode-${RUNNER_SUFFIX}"
fi

REG_TOKEN=$(curl -sX POST -H "Accept: application/vnd.github.v3+json" -H "Authorization: token ${GH_TOKEN}" https://api.github.com/repos/${GH_OWNER}/${GH_REPOSITORY}/actions/runners/registration-token | jq .token --raw-output)

cd /home/docker/actions-runner

./config.sh --help

./config.sh --unattended --url https://github.com/${GH_OWNER}/${GH_REPOSITORY} --token ${REG_TOKEN} --name ${RUNNER_NAME} --labels ${GH_RUNNER_LABELS} --replace

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!