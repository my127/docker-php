#!/bin/bash

function install_sockets()
{
    _sockets_deps_runtime

    if ! has_extension; then
        compile_sockets
    fi

    docker-php-ext-enable sockets
}

function compile_sockets()
{
    _sockets_deps_build

    docker-php-ext-install sockets

    _sockets_clean
}
