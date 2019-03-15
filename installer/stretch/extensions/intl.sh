#!/bin/bash

function install_intl()
{
    _intl_deps_runtime
    _intl_deps_build

    docker-php-ext-install intl

    _intl_clean
}

function _intl_deps_runtime()
{
    install libicu57
}

function _intl_deps_build()
{
    install libicu-dev
}

function _intl_clean()
{
    remove libicu-dev
}
