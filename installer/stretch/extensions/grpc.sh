#!/bin/bash

function install_grpc()
{
    _grpc_deps_build

    pecl install grpc
    docker-php-ext-enable grpc

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
