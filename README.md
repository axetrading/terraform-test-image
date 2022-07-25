Docker image containing dependencies for testing a Terraform module in AxeTrading - currently Terraform,
Python and Boto.

The image can be referenced as: `ghcr.io/axetrading/terraform-test-image:latest`

To use this in your Terraform module, create the following files in your repo:

## `test/*.tf`

Place Terraform files that exercise your module. Create outputs for any values you will need in your tests.

## `test.sh`

Create a small wrapper around the image to run your tests:

```shell
#!/bin/bash

set -eo pipefail

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker run \
    --rm -i -w "$dir" -v "$dir:$dir" \
    -e NO_DESTROY \
    axetrading/terraform-test-image:latest test/check.py
```

The `NO_DESTROY` environment variable can be set to stop the resources being
destroyed while you are iterating on the infrastructure/testss:

```shell
NO_DESTROY=1 ./test.sh
```

## `test/check.py`

Use this to check the resources were created and function as expected:

```python
import boto3
import json
import os

outputs = json.loads(os.environ['TF_OUTPUTS'])

# check resources here
```