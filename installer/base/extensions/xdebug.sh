#!/bin/bash

function install_xdebug()
(
    if ! has_extension xdebug; then
        compile_xdebug
    fi

    docker-php-ext-enable xdebug
)

function compile_xdebug()
(
    set -o errexit -o pipefail

    case "$VERSION" in
            7.*)
                XDEBUG_PACKAGE="xdebug-2.9.8"
                printf "\n" | pecl install "$XDEBUG_PACKAGE"
                ;;
            *)
                XDEBUG_PACKAGE="xdebug"
                printf "\n" | pecl install "$XDEBUG_PACKAGE"
    esac
)
