#!/bin/bash

function install_igbinary()
{
    if ! has_extension igbinary; then
        compile_igbinary
    fi
    docker-php-ext-enable igbinary
}

function compile_igbinary()
{
    case "$VERSION" in
            "5.6")
                printf "\n" | pecl install igbinary-2.0.8
                ;;
            *)
                printf "\n" | pecl install igbinary
    esac
}
