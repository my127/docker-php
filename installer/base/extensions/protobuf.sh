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
    case "$VERSION" in
        7.*)
            printf "\n" | pecl install protobuf-3.20.3
            ;;
        8.0)
            printf "\n" | pecl install protobuf-3.25.3
            ;;
        *)
            printf "\n" | pecl install protobuf
    esac
}
