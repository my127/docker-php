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
            "5.6")
                printf "\n" | pecl install protobuf-3.12.4
                ;;
            *)
                printf "\n" | pecl install protobuf
    esac
}
