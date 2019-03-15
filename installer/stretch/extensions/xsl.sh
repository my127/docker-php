#!/bin/bash

function install_xsl()
{
    _xsl_deps_runtime
    _xsl_deps_build

    docker-php-ext-install xsl

    _xsl_clean
}

function _xsl_deps_runtime()
{
    install libxslt1.1
}

function _xsl_deps_build()
{
    install libxslt1-dev
}

function _xsl_clean()
{
    remove libxslt1-dev
}
