#!/bin/bash

set -e -o pipefail -x

export BUILD_DEPS=(autoconf g++ make)
export BUILD_DEPS_CLEAN=()

source ./lib/functions.sh

function main()
{
    local extension
    for extension in "$@"
    do
        enable "$extension"
    done
}

VERSION="$(echo "$PHP_VERSION" | cut -d. -f1-2)"
export VERSION

bootstrap
main "$@"
clean
