#!/bin/bash

function install_zip()
{
    _zip_deps_runtime
    _zip_deps_build

    docker-php-ext-install zip

    _zip_clean
}

function _zip_deps_runtime()
{
    install zip
}

function _zip_deps_build()
{
    install libzip-dev
}

function _zip_clean()
{
    remove libzip-dev
}
