#!/bin/bash

function install_ssh2()
{
    if ! has_extension ssh2; then
        compile_ssh2
    fi

    if has_extension ssh2; then
        docker-php-ext-enable ssh2
    fi
}

function compile_ssh2()
{
    _ssh2_deps_build
    case "$VERSION" in
        "8.0")
            echo "Skipping ssh2 installation due to unsupported php version"
            ;;
        "5.6")
            printf "\n" | pecl install ssh2-0.13
            ;;
        *)
            # beta release, so need to specify version number
            printf "\n" | pecl install ssh2-1.2
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
