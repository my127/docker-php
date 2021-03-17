#!/bin/bash
set -e -o pipefail

if ! docker image ls -a --format '{{ print .Repository ":" .Tag }}' | grep -q koalaman/shellcheck-alpine:stable; then
  docker pull koalaman/shellcheck-alpine:stable
fi
if ! docker image ls -a --format '{{ print .Repository ":" .Tag }}' | grep -q hadolint/hadolint:latest; then
  docker pull hadolint/hadolint:latest
fi

run_shellcheck()
{
  docker run --rm --volume "$(pwd):/app" koalaman/shellcheck-alpine:stable /bin/sh -c 'find /app -type f ! -path "*/.git/*" ! -name "*.orig" -and \( -name "*.sh" -or -perm -0111 \) -print -exec shellcheck --exclude SC1008,SC1091 {} +'
}

run_hadolint()
{
  docker run --rm --volume "$(pwd):/app" hadolint/hadolint:latest /bin/sh -c 'find /app -type f -name "*Dockerfile" ! -path "*/.git/*" ! -name "*.orig" -print -exec hadolint --ignore DL3003 --ignore DL3008 --ignore DL3016 --ignore SC1091 --ignore DL3002 {} +'
}

run_shellcheck
run_hadolint
