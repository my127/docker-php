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
    printf "\n" | pecl install igbinary
}
