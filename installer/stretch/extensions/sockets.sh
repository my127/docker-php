#!/bin/bash

function install_sockets()
{
    _sockets_deps_runtime
    _sockets_deps_build

    docker-php-ext-install sockets

    _sockets_clean
}

function _sockets_deps_runtime()
{
    :
}

function _sockets_deps_build()
{
    :
}

function _sockets_clean()
{
    :
}
