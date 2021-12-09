#!/bin/bash

function install_sodium()
{
    _sodium_deps_runtime

    if ! has_extension sodium; then
        compile_sodium
    fi

    docker-php-ext-enable sodium
}

function compile_sodium()
{
    _sodium_deps_build

    docker-php-ext-configure sodium "--with-sodium=/usr/lib/$(uname -m)-linux-gnu/libsodium.so.23"
    docker-php-ext-install sodium

    _sodium_clean
}

function _sodium_deps_runtime()
{
    install libsodium23
}

function _sodium_deps_build()
{
    install libsodium-dev
}

function _sodium_clean()
{
    remove libsodium-dev
}
