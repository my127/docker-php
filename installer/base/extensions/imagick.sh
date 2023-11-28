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

    case "$VERSION" in
            "8.0")
                set -e
                curl --fail --silent --show-error --location --output /tmp/imagick.zip https://github.com/Imagick/imagick/archive/c5b8086b5d96c7030e6d4e6ea9a5ef49055d8273.zip
                cd /tmp/
                unzip imagick.zip
                cd /tmp/imagick-*
                phpize
                ./configure
                make
                make install
                cd /root/installer
                rm -rf /tmp/imagick*
                ;;
            *)
                if ! printf "\n" | pecl install imagick; then
                    return 1
                fi
    esac

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
