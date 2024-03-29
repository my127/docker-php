#!/bin/bash

function install_tideways()
{
    _tideways_deps_build
    _tideways_deps_runtime
}

function compile_tideways()
{
    :
}

function _tideways_deps_runtime()
{
    local CLI_PACKAGE=''
    if [[ "$IMAGE_TYPE" == "console" ]]; then
        CLI_PACKAGE='tideways-cli'
    fi

    install \
      tideways-php \
      "$CLI_PACKAGE"

    rm -f /usr/local/etc/php/conf.d/tideways.ini
}

function _tideways_deps_build()
{
    install \
      apt-transport-https \
      gnupg2

    echo 'deb https://packages.tideways.com/apt-packages-main any-version main' > /etc/apt/sources.list.d/tideways.list
    curl --fail --silent --show-error --location 'https://packages.tideways.com/key.gpg' | apt-key add -
    apt-get update -qq
}
