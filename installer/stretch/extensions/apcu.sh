#!/bin/bash

function install_apcu()
{
    if ! has_extension apcu; then
        compile_apcu
    fi
    docker-php-ext-enable apcu
}

function compile_apcu()
{
    case "$VERSION" in
            "5.6")
                printf "\n" | pecl install apcu-4.0.11
                ;;
            *)
                printf "\n" | pecl install apcu
    esac
}
