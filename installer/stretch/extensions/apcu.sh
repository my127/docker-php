#!/bin/bash

function install_apcu()
{

    case "$VERSION" in
            "5.6")
                printf "\n" | pecl install apcu-4.0.11
                ;;
            *)
                printf "\n" | pecl install apcu
    esac
    docker-php-ext-enable apcu
}
