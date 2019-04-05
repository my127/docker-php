#!/bin/bash

function install_bz2()
{
    _bz2_deps_runtime
    _bz2_deps_build

    docker-php-ext-install bz2

    _bz2_clean
}

function _bz2_deps_runtime()
{
    install bzip2
}

function _bz2_deps_build()
{
    install libbz2-dev
}

function _bz2_clean()
{
    remove libbz2-dev
}
