#!/bin/bash

set -e -o pipefail

for service in $(docker-compose config --services | grep base); do
  echo
  echo "Testing service ${service}"
  # shellcheck disable=SC2016
  docker-compose run --rm "$service" bash -e -c 'cd /root/installer/; for extension in extensions/*; do echo -n "Installing ${extension}..."; ./enable.sh "$(expr match "$extension" "extensions/\(.*\).sh")" > /tmp/ext-install.log 2>&1 || (echo " failure" && cat /tmp/ext-install.log && exit 1); echo " success"; done; php -m; php -v'
done

for service in $(docker-compose config --services | grep console); do
  # shellcheck disable=SC2016
  docker-compose run --rm "$service" bash -e -c 'php -m; php -v'
done
