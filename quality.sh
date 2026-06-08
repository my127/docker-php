#!/bin/bash
set -e -o pipefail

if ! docker image ls -a --format '{{ print .Repository ":" .Tag }}' | grep -q koalaman/shellcheck-alpine:stable; then
  docker pull koalaman/shellcheck-alpine:stable
fi

run_shellcheck()
{
  docker run --rm --volume "$(pwd):/app" koalaman/shellcheck-alpine:stable /bin/sh -c 'find /app -type f ! -path "*/.git/*" ! -name "*.orig" -and \( -name "*.sh" -or -perm -0111 \) -print -exec shellcheck --exclude SC1008,SC1091 {} +'
}
run_shellcheck
