#!/bin/bash

set -e
set -x

function main()
{
    for extension in "$@"
    do
        enable $extension
    done
}

function enable()
{
    local extension="$1"

    local installer_file="extensions/${extension}.sh"
    local installer_name="install_${extension}"

    if [ -f $installer_file ]; then
        declare -F "$installer_name" &>/dev/null || source "$installer_file"
        $installer_name
    else
        docker-php-ext-install $extension
    fi
}

function bootstrap()
{
    echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends
    echo 'APT::Install-Suggests 0;'   >> /etc/apt/apt.conf.d/01norecommends

    apt-get update -qq

    install \
      apt-transport-https \
      autoconf \
      g++ \
      make
}

function clean()
{
    remove \
      autoconf \
      g++ \
      make

    apt-get auto-remove -qq -y
    apt-get clean
    
    rm -rf /var/lib/apt/lists/*
}

function install()
{
    DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install $@
}

function remove()
{
    DEBIAN_FRONTEND=noninteractive apt-get -y --purge remove $@
}

VERSION=$(echo $PHP_VERSION | cut -c 1-3)

bootstrap
main $@
clean
