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
}

function _gmp_clean()
{
    remove libgmp-dev
}
