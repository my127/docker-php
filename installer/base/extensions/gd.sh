#!/bin/bash

function install_gd()
{
    _gd_deps_runtime
    if ! has_extension gd; then
        compile_gd
    fi
    docker-php-ext-enable gd
}

function compile_gd()
{
    _gd_deps_build

    case "$VERSION" in
            "7.3")
                docker-php-ext-configure gd \
                  --with-gd \
                  --with-freetype-dir=/usr/include/ \
                  --with-png-dir=/usr/include/ \
                  --with-jpeg-dir=/usr/include/ \
                  --with-webp-dir=/usr/include/ \
                  --with-xpm-dir=/usr/include/
                ;;
            *)
                docker-php-ext-configure gd \
                  --enable-gd \
                  --with-freetype \
                  --with-jpeg \
                  --with-webp \
                  --with-xpm
    esac

    docker-php-ext-install gd

    _gd_clean
}

function _gd_deps_runtime()
{
    local WEBP_PACKAGE=libwebp7
    if [ "$BASEOS" = buster ] || [ "$BASEOS" = bullseye ]; then
      WEBP_PACKAGE=libwebp6
    fi

    install \
      libfreetype6 \
      libjpeg62-turbo \
      libpng16-16 \
      "$WEBP_PACKAGE" \
      libxpm4 \
      zlib1g
}

function _gd_deps_build()
{
    install \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libpng-dev \
      libwebp-dev \
      libxpm-dev \
      zlib1g-dev
}

function _gd_clean()
{
    remove \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libpng-dev \
      libwebp-dev \
      libxpm-dev \
      zlib1g-dev
}
