#!/bin/bash

function install_redis()
{
    pecl install -o -f redis
    docker-php-ext-enable redis
}
