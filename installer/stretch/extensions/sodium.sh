#!/bin/bash

function install_sodium()
{
    _sodium_deps_runtime

    if ! has_extension sodium; then
        compile_sodium
    fi

    case "$VERSION" in
        "5.6")
            ;&
        "7.0")
            ;&
        "7.1")
            echo "Skipping sodium enable, unsupported php version"
            return 0
            ;;
    esac

    docker-php-ext-enable sodium
}

function compile_sodium()
{
    _sodium_deps_build

    case "$VERSION" in
        "5.6")
            ;&
        "7.0")
            ;&
        "7.1")
            echo "Skipping sodium install, unsupported php version"
            ;;
        *)
            docker-php-ext-configure sodium "--with-sodium=/usr/lib/$(uname -m)-linux-gnu/libsodium.so.23"
            docker-php-ext-install sodium
            ;;
    esac

    _sodium_clean
}

function _sodium_deps_runtime()
{
    install libsodium23
}

function _sodium_deps_build()
{
    install libsodium-dev/stretch-backports
}

function _sodium_clean()
{
    remove libsodium-dev
}
