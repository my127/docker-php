#!/bin/bash

function install_apcu()
{
    if ! has_extension apcu; then
        compile_apcu
    fi
    docker-php-ext-enable apcu
}

function compile_apcu()
{
    printf "\n" | pecl install apcu
}
