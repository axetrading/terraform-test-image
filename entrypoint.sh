#!/bin/bash

set -eo pipefail

check_script="$1"
if [ -z "$check_script" ]; then
    echo 'Please provide python script to check resources as an argument' >&2
    exit 1
fi

export TF_GLOBAL_ARGS='-chdir=test'
export TF_IN_AUTOMATION=true
export TF_INPUT=0

terraform $TF_GLOBAL_ARGS init

terraform $TF_GLOBAL_ARGS plan -out=plan
terraform $TF_GLOBAL_ARGS apply plan

export TF_OUTPUTS="$(terraform $TF_GLOBAL_ARGS output -json)"

set +e
python3 "$check_script"
exit_status=$?
set -e

if [ -z "$NO_DESTROY" ]; then
    terraform $TF_GLOBAL_ARGS apply -destroy -auto-approve
fi

if [ "$exit_status" -ne "0" ]; then
    echo >&2
    echo error: tests failed - see above >&2
    exit $exit_status
fi
