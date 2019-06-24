#!/bin/bash

function install_apcu()
{
    printf "\n" | pecl install apcu
    docker-php-ext-enable apcu
}
