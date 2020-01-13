#!/bin/bash

function install_rdkafka()
{
    _rdkafka_deps_runtime
    _rdkafka_deps_build

    pecl install rdkafka-3.1.3
    docker-php-ext-enable rdkafka

    _rdkafka_clean
}

function _rdkafka_deps_runtime()
{
    install -t stretch-backports librdkafka++1 librdkafka1
}

function _rdkafka_deps_build()
{
    install -t stretch-backports librdkafka-dev
}

function _rdkafka_clean()
{
    remove librdkafka-dev
}
