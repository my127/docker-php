#!/bin/bash

function install_event()
{
    if ! has_extension event; then
        compile_event
    fi

    _event_deps_runtime

    docker-php-ext-enable --ini-name zz-docker-php-ext-event.ini event
}

function compile_event()
{
    _event_deps_build

    local PACKAGE_NAME="event"
    case "$VERSION" in
        "8.0")
            PACKAGE_NAME="event-3.0.2"
            ;;
    esac

    if ! printf "\n" | pecl install "$PACKAGE_NAME"; then
        return 1
    fi

    _event_clean
}

function _event_deps_runtime()
{
    enable \
      sockets

    install \
      libevent-2.1-7 \
      libevent-extra-2.1-7 \
      libevent-openssl-2.1-7
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
