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

    case "$VERSION" in
        "5.6")
            pecl install rdkafka-4.1.2
            ;;
        *)
            pecl install rdkafka
    esac

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
