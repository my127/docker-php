#!/bin/bash

function install_blackfire()
{
    install_blackfire_probe
    if [[ "$IMAGE_TYPE" == "console" ]]; then
        install_blackfire_cli
    fi
}

function compile_blackfire()
{
    install_blackfire
}

function install_blackfire_probe()
{
    local version
    version="$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;")"
    curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s "https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version"
    mkdir -p /tmp/blackfire
    tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire
    mv /tmp/blackfire/blackfire-*.so "$(php -r "echo ini_get('extension_dir');")/blackfire.so"
    rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz
}

function install_blackfire_cli()
{
    mkdir -p /tmp/blackfire-cli
    curl -A "Docker" -o /tmp/blackfire-cli.tar.gz -L https://blackfire.io/api/v1/releases/client/linux_static/amd64
    tar zxpf /tmp/blackfire-cli.tar.gz -C /tmp/blackfire-cli
    mv /tmp/blackfire-cli/blackfire /usr/bin/blackfire
    rm -rf /tmp/blackfire-cli /tmp/blackfire-cli.tar.gz
}
