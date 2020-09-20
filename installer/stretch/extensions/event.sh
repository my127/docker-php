#!/bin/bash

function install_event()
{
    _event_deps_runtime
    _event_deps_build

    printf "\n" | pecl install event
    docker-php-ext-enable event

    _event_clean
}

function _event_deps_runtime()
{
    enable \
      sockets

    install \
      libevent-2.0-5 \
      libevent-extra-2.0-5 \
      libevent-openssl-2.0-5
}

function _event_deps_build()
{
    install \
      libevent-dev \
      libssl-dev
}

function _event_clean()
{
    remove \
      libevent-dev \
      libssl-dev
}
