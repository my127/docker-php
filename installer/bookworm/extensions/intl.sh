#!/bin/bash

function install_intl()
{
    _intl_deps_runtime
    if ! has_extension intl; then
        compile_intl
    fi
    docker-php-ext-enable intl
}

function compile_intl()
{
    _intl_deps_build

    docker-php-ext-install intl

    _intl_clean
}

function _intl_deps_runtime()
{
    install libicu72
}

function _intl_deps_build()
{
    install icu-devtools libicu-dev
}

function _intl_clean()
{
    remove icu-devtools libicu-dev
}
