#!/bin/bash

function install_rdkafka()
{
    _rdkafka_deps_runtime
    _rdkafka_deps_build

    pecl install rdkafka
    docker-php-ext-enable rdkafka

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
