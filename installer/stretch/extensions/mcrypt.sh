#!/bin/bash

function install_mcrypt()
{
    _mcrypt_deps_runtime
    _mcrypt_deps_build

    case "$VERSION" in
            "5.6")
                docker-php-ext-install mcrypt
                ;;
            "7.0")
                docker-php-ext-install mcrypt
                ;;
            "7.1")
                docker-php-ext-install mcrypt
                ;;
            *)
                printf "\n" | pecl install mcrypt-1.0.2
                docker-php-ext-enable mcrypt
    esac

    _mcrypt_clean
}

function _mcrypt_deps_runtime()
{
    install libmcrypt4
}

function _mcrypt_deps_build()
{
    install libmcrypt-dev
}

function _mcrypt_clean()
{
    remove libmcrypt-dev
}
