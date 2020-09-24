#!/bin/bash

function install_pgsql()
{
    _pgsql_deps_runtime

    if ! has_extension pgsql; then
        compile_pgsql
    fi
    docker-php-ext-enable pgsql
}

function compile_pgsql()
{
    _pgsql_deps_build

    docker-php-ext-install pgsql

    _pgsql_clean
}

function _pgsql_deps_runtime()
{
    install libpq5
}

function _pgsql_deps_build()
{
    install libpq-dev
}

function _pgsql_clean()
{
    remove libpq-dev
}
