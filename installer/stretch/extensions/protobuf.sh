#!/bin/bash

function install_protobuf()
{
    case "$VERSION" in
            "5.6")
                printf "\n" | pecl install protobuf-3.12.4
                ;;
            *)
                printf "\n" | pecl install protobuf
    esac

    docker-php-ext-enable protobuf
}
