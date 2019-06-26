#!/bin/bash

function enable()
{
    local extension="$1"

    if php -m | grep -i "^${extension}$" > /dev/null; then
        echo "extension ${extension} is already installed."
        return
    fi

    enable_without_check "$extension"
}

function enable_without_check()
{
    local extension="$1"
    local installer_file="extensions/${extension}.sh"
    local installer_name="install_${extension}"

    if [ -f $installer_file ]; then
        # shellcheck source=../extensions/$installer_file
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

    for package in "${BUILD_DEPS[@]}"
    do
        if [[ ! -x "$(command -v ${package})" ]]; then
            install $package
            BUILD_DEPS_CLEAN+=("${package}")
        fi
    done
}

function clean()
{
    for package in "${BUILD_DEPS_CLEAN[@]}"
    do
        remove $package
    done

    apt-get auto-remove -qq -y
    apt-get clean

    rm -rf /var/lib/apt/lists/*
}

function install()
{
    DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install "$@"
}

function remove()
{
    DEBIAN_FRONTEND=noninteractive apt-get -y --purge remove "$@"
}
