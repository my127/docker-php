#!/bin/bash

function install_xdebug()
{
    case "$VERSION" in
            "5.6")
                printf "\n" | pecl install xdebug-2.5.5
                ;;
            *)
                printf "\n" | pecl install xdebug
    esac

    docker-php-ext-enable xdebug
}
