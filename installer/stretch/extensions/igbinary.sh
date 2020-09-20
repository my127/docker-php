#!/bin/bash

function install_igbinary()
{
    printf "\n" | pecl install igbinary
    docker-php-ext-enable igbinary
}
