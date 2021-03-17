#!/bin/bash

set -e -o pipefail

docker pull koalaman/shellcheck:latest
run_shellcheck()
{
  local script="$1"
  echo -n "Linting '$script': "
  docker run --rm -i koalaman/shellcheck:latest --exclude SC1008,SC1091 - < "$script" && echo "OK"
}
export -f run_shellcheck

find . -type f ! -path "./.git/*" ! -name "*.orig" -and \( -name "*.sh" -or -perm -0111 \) -exec bash -ec 'run_shellcheck "$0"' {} \;
