#!/bin/bash

set -e -o pipefail

BUILD="${BUILD:-}"

SERVICES=($(docker-compose config --services | grep -E "${BUILD}"))

for service in "${SERVICES[@]}"; do
  until docker-compose build --pull "$service"; do
    echo "Build failed for $service; retrying in 5 seconds..."
    sleep 5
  done
done
