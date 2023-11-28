#!/bin/bash

function install_ssh2()
{
    if ! has_extension ssh2; then
        compile_ssh2
    fi

    docker-php-ext-enable ssh2
}

function compile_ssh2()
{
    _ssh2_deps_build
    case "$VERSION" in
        "5.6")
            printf "\n" | pecl install ssh2-0.13
            ;;
        *)
            printf "\n" | pecl install ssh2
    esac

    _ssh2_clean
}

function _ssh2_deps_build()
{
    install \
      libgcrypt20-dev \
      libgpg-error-dev \
      libssh2-1-dev
}

function _ssh2_clean()
{
    remove \
      libgcrypt20-dev \
      libgpg-error-dev \
      libssh2-1-dev
}
