#!/bin/bash

set -e
set -x

export BUILD_DEPS=(autoconf g++ make)
export BUILD_DEPS_CLEAN=()

source ./lib/functions.sh

function main()
{
    for extension in "$@"
    do
        enable_without_check "$extension"
    done
}

VERSION="$(echo "$PHP_VERSION" | cut -c 1-3)"
export VERSION

bootstrap
main "$@"
clean
