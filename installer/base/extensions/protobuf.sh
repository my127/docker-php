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
            printf "\n" | pecl install protobuf-3.20.1
            ;;
        *)
            printf "\n" | pecl install protobuf
    esac
}
