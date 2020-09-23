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
}

function _tideways_deps_build()
{
    install \
      apt-transport-https \
      gnupg2

    echo 'deb https://packages.tideways.com/apt-packages debian main' > /etc/apt/sources.list.d/tideways.list
    curl -L -sS 'https://packages.tideways.com/key.gpg' | apt-key add -
    apt-get update -qq
}
