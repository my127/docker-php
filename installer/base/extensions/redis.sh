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
    printf "\n" | pecl install -o -f redis
}
