#!/bin/bash

function install_protobuf()
{
    if ! has_extension protobuf; then
        compile_protobuf
    fi

    docker-php-ext-enable protobuf
}

function compile_protobuf()
{
    printf "\n" | pecl install protobuf
}
