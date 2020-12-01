#!/bin/bash

function install_opcache()
{
    if ! has_extension opcache; then
        compile_sockets
    fi

    docker-php-ext-enable opcache
}

function compile_sockets()
{
    docker-php-ext-install opcache
}
