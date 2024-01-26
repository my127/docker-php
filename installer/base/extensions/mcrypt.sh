#!/bin/bash

function install_mcrypt()
{
    _mcrypt_deps_runtime

    if ! has_extension mcrypt; then
        compile_mcrypt
    fi

    docker-php-ext-enable mcrypt
}

function compile_mcrypt()
{
    _mcrypt_deps_build

    printf "\n" | pecl install mcrypt

    _mcrypt_clean
}

function _mcrypt_deps_runtime()
{
    install libmcrypt4 libltdl7
}

function _mcrypt_deps_build()
{
    install libmcrypt-dev
}

function _mcrypt_clean()
{
    remove libmcrypt-dev
}
