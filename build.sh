#!/bin/bash

set -e -o pipefail

BUILD="${BUILD:-}"

SERVICES="$(docker-compose config --services | grep -E "${BUILD}")"

# shellcheck disable=SC2086
docker-compose build ${SERVICES[*]}
