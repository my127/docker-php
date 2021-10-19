#!/bin/bash

set -e -o pipefail

# shellcheck disable=SC2086
docker buildx bake -f docker-bake.hcl ${BUILD:-} "$@"
