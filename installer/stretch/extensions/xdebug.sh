#!/bin/bash

function install_xdebug()
{
    case "$VERSION" in
            "5.6")
                printf "\n" | pecl install xdebug-2.5.5 && docker-php-ext-enable xdebug
                ;;
            *)
                printf "\n" | pecl install xdebug && docker-php-ext-enable xdebug
    esac
}
