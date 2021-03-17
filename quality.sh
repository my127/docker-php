#!/bin/bash
set -e -o pipefail

docker pull koalaman/shellcheck-alpine:stable
run_shellcheck()
{
  docker run --rm --volume "$(pwd):/app" koalaman/shellcheck-alpine:stable /bin/sh -c 'find /app -type f ! -path "*/.git/*" ! -name "*.orig" -and \( -name "*.sh" -or -perm -0111 \) -print -exec shellcheck --exclude SC1008,SC1091 {} +'
}
run_shellcheck
