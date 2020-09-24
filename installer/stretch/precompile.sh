#!/bin/bash

set -e -o pipefail

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
        if ! compile "$extension_name" > /tmp/ext-install.log 2>&1; then
            echo " failure"
            cat /tmp/ext-install.log
            exit 1
        fi
        echo " success"
    done

    if [ -f /tmp/ext-install.log ]; then
        rm /tmp/ext-install.log
    fi
}

VERSION="$(echo "$PHP_VERSION" | cut -c 1-3)"
export VERSION

bootstrap
main
clean
