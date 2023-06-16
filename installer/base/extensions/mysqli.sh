#!/bin/bash

function install_mysqli()
{
    _mysqli_deps_runtime

    if ! has_extension mysqli; then
        compile_mysqli
    fi
    docker-php-ext-enable mysqli
}

function compile_mysqli()
{
    _mysqli_deps_build

    docker-php-ext-install mysqli

    _mysqli_clean
}

function _mysqli_deps_runtime()
{
    :
}

function _mysqli_deps_build()
{
    :
}

function _mysqli_clean()
{
    :
}
