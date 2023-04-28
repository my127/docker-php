#!/bin/bash

function install_zip()
{
    _zip_deps_runtime

    if ! has_extension zip; then
        compile_zip
    fi

    docker-php-ext-enable zip
}

function compile_zip()
{
    _zip_deps_build

    docker-php-ext-install zip

    _zip_clean
}

function _zip_deps_runtime()
{
    install libzip4
}

function _zip_deps_build()
{
    install zlib1g-dev libzip-dev
}

function _zip_clean()
{
    remove zlib1g-dev libzip-dev
}
