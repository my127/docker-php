#!/bin/bash

function install_opcache()
{
    if ! has_extension opcache; then
        compile_opcache
    fi

    docker-php-ext-enable opcache
}

function compile_opcache()
{
    if ! has_extension opcache; then
        docker-php-ext-install opcache
    fi
}
