#!/bin/bash

function install_sockets()
{
    if ! has_extension; then
        compile_sockets
    fi

    docker-php-ext-enable sockets
}

function compile_sockets()
{
    docker-php-ext-install sockets
}
