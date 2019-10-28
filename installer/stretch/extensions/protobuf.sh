#!/bin/bash

function install_protobuf()
{
    pecl install protobuf
    docker-php-ext-enable protobuf
}
