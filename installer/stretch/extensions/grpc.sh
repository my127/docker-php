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
    pecl install grpc
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
