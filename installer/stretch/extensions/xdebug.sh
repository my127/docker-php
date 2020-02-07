#!/bin/bash

function install_xdebug()
{
    local XDEBUG_PACKAGE="xdebug"
    case "$VERSION" in
            "5.6")
                XDEBUG_PACKAGE="xdebug-2.5.5"
                ;;
            "7.0")
                XDEBUG_PACKAGE="xdebug-2.8.1"
                ;;
            *)
    esac

    printf "\n" | pecl install "$XDEBUG_PACKAGE"

    docker-php-ext-enable xdebug
}
