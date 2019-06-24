#!/bin/bash

function install_imagick()
{
    _imagick_deps_runtime

    printf "\n" | pecl install imagick
    docker-php-ext-enable imagick
}

function _imagick_deps_runtime()
{
    install \
      libmagickwand-dev
}
