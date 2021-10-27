#!/bin/bash

set -e -o pipefail

BUILD="${BUILD:-}"

for SERVICE in $(docker-compose config --services | grep -E "${BUILD}" | grep base); do
  echo
  echo "Testing service ${service}"
  docker-compose run --rm -v "$(pwd)/test.extensions.sh:/app/test.extensions.sh" "${SERVICE}" /app/test.extensions.sh
done

for SERVICE in $(docker-compose config --services | grep -E "${BUILD}" | grep console); do
  # shellcheck disable=SC2016
  docker-compose run --rm "${SERVICE}" bash -e -c 'php -m; php -v'
done
