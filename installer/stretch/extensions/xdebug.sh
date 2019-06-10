#!/bin/bash

function install_xdebug()
{
    case "$VERSION" in
            "5.6")
                BEFORE_PWD=$(pwd) \
                    && mkdir -p /opt/xdebug \
                    && cd /opt/xdebug \
                    && curl https://xdebug.org/files/xdebug-2.5.5.tgz -o xdebug-2.5.5.tgz \
                    && echo "72108bf2bc514ee7198e10466a0fedcac3df9bbc5bd26ce2ec2dafab990bf1a4" "xdebug-2.5.5.tgz" | sha256sum --check \
                    && tar -xzvf xdebug-2.5.5.tgz \
                    && cd xdebug-2.5.5 \
                    && phpize \
                    && ./configure --enable-xdebug \
                    && make clean \
                    && sed -i 's/-O2/-O0/g' Makefile \
                    && make \
                    && make test \
                    && make install \
                    && cd "${BEFORE_PWD}" \
                    && rm -r /opt/xdebug
                ;;
            *)
                printf "\n" | pecl install xdebug
    esac

    docker-php-ext-enable xdebug
}
