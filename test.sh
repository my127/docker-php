#!/bin/bash

for service in $(docker-compose config --services | grep base); do
  # shellcheck disable=SC2016
  docker-compose run --rm "$service" bash -e -c 'cd /root/installer/; for extension in extensions/*; do ./enable.sh "$(expr match "$extension" "extensions/\(.*\).sh")"; done; php -m; php -v'
done

for service in $(docker-compose config --services | grep console); do
  # shellcheck disable=SC2016
  docker-compose run --rm "$service" bash -e -c 'php -m; php -v'
done
