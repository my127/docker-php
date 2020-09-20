#!/bin/bash

function install_ssh2()
{
    _ssh2_deps_build
    case "$VERSION" in
        "5.6")
            printf "\n" | pecl install ssh2-0.1.3
            ;;
        *)
            # beta release, so need to specify version number
            printf "\n" | pecl install ssh2-1.2
    esac

    docker-php-ext-enable ssh2

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
