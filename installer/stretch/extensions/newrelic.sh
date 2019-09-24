#!/bin/bash

function install_newrelic()
{
    curl -L http://download.newrelic.com/php_agent/release/newrelic-php5-9.1.0.246-linux.tar.gz | tar -C /tmp -zx

    export NR_INSTALL_USE_CP_NOT_LN=1
    export NR_INSTALL_SILENT=1

    /tmp/newrelic-php5-*/newrelic-install install
    rm -rf /tmp/newrelic-php5- /tmp/nrinstall
}
