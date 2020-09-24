#!/bin/bash

function install_imagick()
{
    _imagick_deps_runtime
    if ! has_extension imagick; then
        compile_imagick true
    fi

    docker-php-ext-enable imagick
}

function compile_imagick()
{
    local KEEP_DEPS="${1:-}"

    _imagick_deps_runtime

    printf "\n" | pecl install imagick

    if [ -z "$KEEP_DEPS" ]; then
        _imagick_clean_runtime
    fi
}

function _imagick_deps_runtime()
{
    install \
      imagemagick \
      libmagickwand-dev
}

function _imagick_clean_runtime()
{
    remove \
      imagemagick \
      libglib2.0-data \
      libmagickwand-dev \
      shared-mime-info
}
