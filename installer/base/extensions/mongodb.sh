#!/bin/bash

function install_mongodb()
{
    if ! has_extension mongodb; then
        compile_mongodb
    fi
    docker-php-ext-enable mongodb
}

function compile_mongodb()
{
    _mongodb_deps_build

    case "$VERSION" in
        7.3)
            pecl install mongodb-1.16.2
            ;;
        *)
            pecl install mongodb
    esac

    _mongodb_clean
}

function _mongodb_deps_build()
{
    install libssl-dev
}

function _mongodb_clean()
{
    remove libssl-dev
}
