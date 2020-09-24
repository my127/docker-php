#!/bin/bash

function install_sodium()
{
    _sodium_deps_runtime

    if ! has_extension sodium; then
        compile_sodium
    fi

    if has_extension sodium; then
        docker-php-ext-enable sodium
    fi
}

function compile_sodium()
{
    _sodium_deps_build

    case "$VERSION" in
            "7.2")
                docker-php-ext-configure sodium --with-sodium=/usr/lib/x86_64-linux-gnu/libsodium.so.23
                docker-php-ext-install sodium
                ;;
            "7.3")
                docker-php-ext-configure sodium --with-sodium=/usr/lib/x86_64-linux-gnu/libsodium.so.23
                docker-php-ext-install sodium
                ;;
            *)
                echo "Skipping sodium install, unsupported php version"
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
