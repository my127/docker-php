#!/bin/bash

function install_gmp()
{
    _gmp_deps_runtime
    _gmp_deps_build

    docker-php-ext-install gmp

    _gmp_clean
}

function _gmp_deps_runtime()
{
    install libgmp10
}

function _gmp_deps_build()
{
    install libgmp-dev
    # Fix for gmp headers not being found, from https://superuser.com/a/1404434
    ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h
}

function _gmp_clean()
{
    remove libgmp-dev
}
