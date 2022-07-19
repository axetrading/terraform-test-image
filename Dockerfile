FROM hashicorp/terraform:1.2.5

LABEL org.opencontainers.image.source="https://github.com/axetrading/terraform-test-image"

RUN apk add -U python3 py3-boto3
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/bin/sh", "/entrypoint.sh" ]