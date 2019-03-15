#!/bin/bash

function install_soap()
{
    _soap_deps_runtime
    _soap_deps_build

    docker-php-ext-install soap

    _soap_clean
}

function _soap_deps_runtime()
{
    install libxml2
}

function _soap_deps_build()
{
    install libxml2-dev
}

function _soap_clean()
{
    remove libxml2-dev
}
