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

    case "$VERSION" in
        "8.0")
            echo "Skipping xmlrpc due to unsupported php version"
            ;;
        *)
            docker-php-ext-install xmlrpc
    esac

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
