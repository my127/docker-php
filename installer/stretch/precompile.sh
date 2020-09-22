#!/bin/bash

set -e

export BUILD_DEPS=(autoconf g++ make)
export BUILD_DEPS_CLEAN=()

source ./lib/functions.sh

function main()
{
    for extension in extensions/*
    do
        echo -n "Installing ${extension}..."
        compile "$(expr match "$extension" "extensions/\(.*\).sh")" > /tmp/ext-install.log 2>&1 || (echo " failure" && cat /tmp/ext-install.log && exit 1)
        echo " success"
    done
}

VERSION="$(echo "$PHP_VERSION" | cut -c 1-3)"
export VERSION

bootstrap
main
clean
