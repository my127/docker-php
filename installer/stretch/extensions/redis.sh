#!/bin/bash

function install_redis()
{
    case "$VERSION" in
            "5.6")
                printf "\n" | pecl install -o -f redis-2.2.8
                ;;
            *)
                printf "\n" | pecl install -o -f redis
    esac

    docker-php-ext-enable redis
}
