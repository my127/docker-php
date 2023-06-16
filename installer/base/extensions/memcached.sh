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

    case "$VERSION" in
            "5.6")
                printf "\n" | pecl install memcached-2.2.0
                ;;
            *)
                printf "\n" | pecl install memcached
    esac
    _memcached_clean
}

function _memcached_deps_runtime()
{
    install libmemcached11 libmemcachedutil2
}

function _memcached_deps_build()
{
    install libmemcached-dev zlib1g-dev
}

function _memcached_clean()
{
    remove libmemcached-dev zlib1g-dev
}
