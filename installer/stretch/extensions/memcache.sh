#!/bin/bash

function install_memcache()
{
    _memcache_deps_runtime
    _memcache_deps_build

    case "$VERSION" in
            "5.6")
                printf "\n" | pecl install memcached-2.2.0 && docker-php-ext-enable memcached
                ;;
            *)
                printf "\n" | pecl install memcached && docker-php-ext-enable memcached
    esac

    _memcache_clean
}

function _memcache_deps_runtime()
{
    install libmemcached11 libmemcachedutil2
}

function _memcache_deps_build()
{
    install libmemcached-dev zlib1g-dev
}

function _memcache_clean()
{
    remove libmemcached-dev zlib1g-dev
}
