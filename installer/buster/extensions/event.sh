#!/bin/bash

function install_event()
{
    if ! has_extension event; then
        compile_event
    fi

    _event_deps_runtime

    docker-php-ext-enable event
}

function compile_event()
{
    _event_deps_build

    case "$VERSION" in
            "8.0")
                # Beta release, so need to specify the version
                pecl install --nobuild event-3.0.0
                cd /tmp/pear/temp/event/
                phpize
                ./configure
                make
                make install
                rm -rf /tmp/pear/temp/event/
                ;;
            *)
                if ! printf "\n" | pecl install event; then
                    return 1
                fi
    esac

    _event_clean
}

function _event_deps_runtime()
{
    enable \
      sockets

    install \
      libevent-2.1-6 \
      libevent-extra-2.1-6 \
      libevent-openssl-2.1-6
}

function _event_deps_build()
{
    enable \
      sockets

    install \
      libevent-dev \
      libssl-dev
}

function _event_clean()
{
    remove \
      libevent-dev \
      libssl-dev

    if [ -f "/usr/local/etc/php/conf.d/docker-php-ext-sockets.ini" ]; then
        rm "/usr/local/etc/php/conf.d/docker-php-ext-sockets.ini"
    fi
}
