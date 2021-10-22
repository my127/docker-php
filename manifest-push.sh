#!/bin/bash

set -e -o pipefail

echo "${DOCKER_REGISTRY_CREDS_PSW}" | docker login --username "${DOCKER_REGISTRY_CREDS_USR}" --password-stdin docker.io

for IMAGE in $(docker compose config --format json | jq -r '.services[].image'); do
    docker manifest create "${IMAGE}" "${IMAGE}-linux-amd64" "${IMAGE}-linux-arm64"
    docker manifest push "${IMAGE}"
done
