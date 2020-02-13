#!/bin/bash

function install_xdebug()
{
    local XDEBUG_PACKAGE="xdebug"
    case "$VERSION" in
            "5.6")
                XDEBUG_PACKAGE="xdebug-2.5.5"
                # Build xdebug manually to avoid a debian compiler bug
                # https://github.com/docker-library/php/issues/133
                pushd /usr/src || return 1

                curl "https://xdebug.org/files/${XDEBUG_PACKAGE}.tgz" -o "${XDEBUG_PACKAGE}.tgz"
                echo "72108bf2bc514ee7198e10466a0fedcac3df9bbc5bd26ce2ec2dafab990bf1a4" "${XDEBUG_PACKAGE}.tgz" | sha256sum --check
                tar -xzvf "${XDEBUG_PACKAGE}.tgz"

                pushd "${XDEBUG_PACKAGE}" || return 1
                phpize
                ./configure --enable-xdebug
                make clean
                # compiler option -O2 changed to -O0
                sed -i 's/-O2/-O0/g' Makefile
                make
                make test
                make install
                popd || return 1

                rm -r "${XDEBUG_PACKAGE}" "${XDEBUG_PACKAGE}.tgz"

                popd || return 1

                ;;
            "7.0")
                XDEBUG_PACKAGE="xdebug-2.8.1"
                ;&
            *)
                printf "\n" | pecl install "$XDEBUG_PACKAGE"

                docker-php-ext-enable xdebug
    esac

    docker-php-ext-enable xdebug
}
