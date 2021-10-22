#!/bin/bash

set -e -o pipefail

BUILD="${BUILD:-}"

SERVICES=($(docker compose config --services | grep -E "${BUILD}"))

docker-compose build "${SERVICES[@]}"
