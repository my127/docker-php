#!/bin/bash

function install_rdkafka()
{
    _rdkafka_deps_runtime
    if ! has_extension rdkafka; then
        compile_rdkafka
    fi
    docker-php-ext-enable rdkafka
}

function compile_rdkafka()
{
    _rdkafka_deps_build

    pecl install rdkafka

    _rdkafka_clean
}

function _rdkafka_deps_runtime()
{
    install librdkafka++1 librdkafka1
}

function _rdkafka_deps_build()
{
    install librdkafka-dev
}

function _rdkafka_clean()
{
    remove librdkafka-dev
}
