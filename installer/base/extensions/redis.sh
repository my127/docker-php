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
            "7.0")
                ;&
            "7.1")
                printf "\n" | pecl install -o -f redis-5.3.7
                ;;
            *)
                printf "\n" | pecl install -o -f redis
    esac
}
