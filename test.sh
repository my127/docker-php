#!/bin/bash

set -e -o pipefail

BUILD="${BUILD:-}"

for service in $(docker-compose config --services | grep -E "${BUILD}" | grep base); do
  echo
  echo "Testing service ${service}"
  docker-compose run --rm -v "$(pwd)/test.extensions.sh:/app/test.extensions.sh" "$service" /app/test.extensions.sh
done

for service in $(docker-compose config --services | grep -E "${BUILD}" | grep console); do
  # shellcheck disable=SC2016
  docker-compose run --rm "$service" bash -e -c 'php -m; php -v'
done
