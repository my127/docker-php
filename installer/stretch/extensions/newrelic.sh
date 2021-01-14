#!/bin/bash

function install_newrelic()
{
    curl -L https://download.newrelic.com/php_agent/archive/9.15.0.293/newrelic-php5-9.15.0.293-linux.tar.gz | tar -C /tmp -zx

    export NR_INSTALL_USE_CP_NOT_LN=1
    export NR_INSTALL_SILENT=1

    # shellcheck disable=SC2211
    /tmp/newrelic-php5-*/newrelic-install install
    rm -rf /tmp/newrelic-php5-* /tmp/nrinstall*
}

function compile_newrelic()
{
    :
}
