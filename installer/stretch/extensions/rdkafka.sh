#!/bin/bash

function install_rdkafka()
{
    _intl_deps_runtime
    _intl_deps_build

    pecl install rdkafka-3.1.3
    docker-php-ext-enable rdkafka

    _intl_clean
}

function _intl_deps_runtime()
{
    install librdkafka++1 librdkafka1
}

function _intl_deps_build()
{
    install librdkafka-dev
}

function _intl_clean()
{
    remove librdkafka-dev
}
