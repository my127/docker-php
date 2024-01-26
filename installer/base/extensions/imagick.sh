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

    _imagick_deps_build
    _imagick_deps_runtime

    set -e
    cd /tmp/
    pecl download imagick-3.7.0
    tar -xzf imagick*.tgz
    cd /tmp/imagick-*/
    patch -p1 < /root/installer/extensions/patches/imagick-preprocessor-fix.patch
    phpize
    ./configure
    make
    make install
    cd /root/installer
    rm -rf /tmp/imagick*

    if [ -z "$KEEP_DEPS" ]; then
        _imagick_clean_runtime
    fi
    _imagick_clean_build
}

function _imagick_deps_build()
{
    install \
      unzip
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

function _imagick_clean_build()
{
    remove \
      unzip
}
