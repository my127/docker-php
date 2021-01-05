#!/bin/bash

function install_grpc()
{
    if ! has_extension grpc; then
        compile_grpc
    fi
    docker-php-ext-enable grpc
}

function compile_grpc()
{
    _grpc_deps_build

    PACKAGE_NAME="grpc"
    case "$VERSION" in
            "8.0")
                PACKAGE_NAME="grpc-1.34.0RC2"
                ;;
    esac

    pecl install "$PACKAGE_NAME"

    _grpc_clean
}

function _grpc_deps_build()
{
    install zlib1g-dev
}

function _grpc_clean()
{
    remove zlib1g-dev
}
