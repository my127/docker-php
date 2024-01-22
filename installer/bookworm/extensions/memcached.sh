#!/bin/bash

function install_memcached()
{
    _memcached_deps_runtime

    if ! has_extension memcached; then
        compile_memcached
    fi

    docker-php-ext-enable memcached
}

function compile_memcached()
{
    _memcached_deps_build

    printf "\n" | pecl install memcached

    _memcached_clean
}

function _memcached_deps_runtime()
{
    install libmemcached11 libmemcachedutil2
}

function _memcached_deps_build()
{
    install libmemcached-dev libssl-dev zlib1g-dev
}

function _memcached_clean()
{
    remove libmemcached-dev libssl-dev zlib1g-dev
}
