#!/bin/bash

function install_igbinary()
{
    case "$VERSION" in
            "5.6")
                printf "\n" | pecl install igbinary-2.0.8
                ;;
            *)
                printf "\n" | pecl install igbinary
    esac
    docker-php-ext-enable igbinary
}
