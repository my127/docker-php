#!/bin/bash

set -e

export BUILD_DEPS=(autoconf g++ make)
export BUILD_DEPS_CLEAN=()

# shellcheck source=./lib/functions.sh
source ./lib/functions.sh

function main()
{
    for extension in extensions/*
    do
        extension_name="${extension%.sh}"
        extension_name="${extension_name#extensions/}"
        echo -n "Installing ${extension}..."
        compile "$extension_name" > /tmp/ext-install.log 2>&1 || (echo " failure" && cat /tmp/ext-install.log && exit 1)
        echo " success"
    done
}

VERSION="$(echo "$PHP_VERSION" | cut -c 1-3)"
export VERSION

bootstrap
main
clean
