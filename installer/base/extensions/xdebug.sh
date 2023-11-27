#!/bin/bash

function install_xdebug()
(
    if ! has_extension xdebug; then
        compile_xdebug
    fi

    docker-php-ext-enable xdebug
)

function compile_xdebug()
(
    set -o errexit -o pipefail

    case "$VERSION" in
            5.6)
                XDEBUG_PACKAGE="xdebug-2.5.5"
                # Build xdebug manually to avoid a debian compiler bug
                # https://github.com/docker-library/php/issues/133
                pushd /usr/src

                curl --fail --silent --show-error --location "https://xdebug.org/files/${XDEBUG_PACKAGE}.tgz" -o "${XDEBUG_PACKAGE}.tgz"
                echo "72108bf2bc514ee7198e10466a0fedcac3df9bbc5bd26ce2ec2dafab990bf1a4" "${XDEBUG_PACKAGE}.tgz" | sha256sum --check
                tar -xzvf "${XDEBUG_PACKAGE}.tgz"

                pushd "${XDEBUG_PACKAGE}"
                phpize
                ./configure --enable-xdebug
                make clean
                # compiler option -O2 changed to -O0
                sed -i 's/-O2/-O0/g' Makefile
                make
                make test
                make install
                popd

                rm -r "${XDEBUG_PACKAGE}" "${XDEBUG_PACKAGE}.tgz"

                popd

                ;;
            7.0)
                XDEBUG_PACKAGE="xdebug-2.8.1"
                printf "\n" | pecl install "$XDEBUG_PACKAGE"
                ;;
            7.*)
                XDEBUG_PACKAGE="xdebug-2.9.8"
                printf "\n" | pecl install "$XDEBUG_PACKAGE"
                ;;
            *)
                XDEBUG_PACKAGE="xdebug"
                printf "\n" | pecl install "$XDEBUG_PACKAGE"
    esac
)
