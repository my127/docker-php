#!/bin/bash

function install_xdebug()
(
    if ! has_extension xdebug; then
        compile_xdebug
    fi

    docker-php-ext-enable xdebug
)

function compile_xdebug()
(
    set -o errexit -o pipefail

    printf "\n" | pecl install xdebug
)
