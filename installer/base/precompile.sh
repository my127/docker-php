#!/bin/bash

set -e -o pipefail

export BUILD_DEPS=(autoconf g++ make)
export BUILD_DEPS_CLEAN=()

# shellcheck source=./lib/functions.sh
source ./lib/functions.sh

function main()
{
    local KEEPALIVE_PID
    for extension in extensions/*.sh
    do
        extension_name="${extension%.sh}"
        extension_name="${extension_name#extensions/}"
        echo -n "Installing ${extension}..."
        bash -c 'for i in {0..40}; do sleep 30 && echo -n "."; done' &
        KEEPALIVE_PID="$!"
        if ! compile "$extension_name" > /tmp/ext-install.log 2>&1; then
            echo " failure"
            cat /tmp/ext-install.log
            kill "$KEEPALIVE_PID" || true
            exit 1
        fi
        kill "$KEEPALIVE_PID" || true
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
