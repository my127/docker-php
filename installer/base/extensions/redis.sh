#!/bin/bash

function install_redis()
{
    if ! has_extension redis; then
        compile_redis
    fi
    docker-php-ext-enable redis
}

function compile_redis()
{
    case "$VERSION" in
            "5.6")
                printf "\n" | pecl install -o -f redis-2.2.8
                ;;
            *)
                printf "\n" | pecl install -o -f redis
    esac
}
