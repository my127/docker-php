#!/bin/bash

function install_newrelic()
(
    set -o errexit -o pipefail

    if [ "$(uname -m )" != x86_64 ]; then
        echo "skipping newrelic extension, it is currently unsupported on architectures other than x86_64 / amd64" >&2
        return 0
    fi

    curl --fail --silent --show-error -L https://download.newrelic.com/php_agent/archive/9.16.0.295/newrelic-php5-9.16.0.295-linux.tar.gz -o '/tmp/newrelic.tar.gz'

    tar -C /tmp -xzvf /tmp/newrelic.tar.gz

    export NR_INSTALL_USE_CP_NOT_LN=1
    export NR_INSTALL_SILENT=1

    # shellcheck disable=SC2211
    /tmp/newrelic-php5-*/newrelic-install install
    rm -rf /tmp/newrelic-php5-* /tmp/nrinstall* /tmp/newrelic.tar.gz
)

function compile_newrelic()
{
    :
}
