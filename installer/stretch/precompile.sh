#!/bin/bash

set -e -o pipefail

export BUILD_DEPS=(autoconf g++ make)
export BUILD_DEPS_CLEAN=()

# shellcheck source=./lib/functions.sh
source ./lib/functions.sh

function main()
{
    local KEEPALIVE_PID
    for extension in extensions/*
    do
        extension_name="${extension%.sh}"
        extension_name="${extension_name#extensions/}"
        echo -n "Installing ${extension}..."
        bash -c 'sleep 60 && echo -n "." && sleep 60 && echo -n "."' &
        KEEPALIVE_PID="$!"
        if ! compile "$extension_name" > /tmp/ext-install.log 2>&1; then
            echo " failure"
            cat /tmp/ext-install.log
            kill "$KEEPALIVE_PID"
            exit 1
        fi
        kill "$KEEPALIVE_PID"
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
