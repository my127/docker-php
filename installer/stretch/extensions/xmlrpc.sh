#!/bin/bash

function install_xmlrpc()
{
    if ! has_extension xmlrpc; then
        compile_xmlrpc
    fi
    docker-php-ext-enable xmlrpc
}

function compile_xmlrpc()
{
    _xmlrpc_deps_build

    docker-php-ext-install xmlrpc

    _xmlrpc_clean
}

function _xmlrpc_deps_build()
{
    install \
      libxml2-dev
}

function _xmlrpc_clean()
{
    remove \
      libxml2-dev
}
