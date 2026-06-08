#!/bin/bash

function available_opcache() {
    version_compare "$PHP_VERSION" lt "8.5"
}

function install_opcache()
{
    if ! available_opcache; then
        echo "Opcache is statically compiled into PHP ${PHP_VERSION}, no installation necessary"
        return
    fi
    if ! has_extension opcache; then
        compile_opcache
    fi

    docker-php-ext-enable opcache
}

function compile_opcache()
{
    if ! available_opcache; then
        echo "Opcache is statically compiled into PHP ${PHP_VERSION}, no compilation necessary"
        return
    fi
    if ! has_extension opcache; then
        docker-php-ext-install opcache
    fi
}
