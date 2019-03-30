#!/bin/bash

function install_pgsql()
{
    _pgsql_deps_runtime
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
