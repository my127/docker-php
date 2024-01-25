#!/bin/bash

set -e

cd /root/installer/

function version_compare() {
    dpkg --compare-versions "$@"
}

before="$(php -m)$(php -v)"
echo "Before: $before"

for extension in extensions/*.sh; do
    echo -n "Installing ${extension}..."
    extension_name="${extension%.sh}"
    extension_name="${extension_name#extensions/}"

    # Some extensions not yet ready for PHP 8.3
    if  [[ "$extension_name" = 'mcrypt' ]] && version_compare "$PHP_VERSION" ge 8.3; then
        echo ' skipped'
        continue
    fi

    # NewRelic PHP agent is currently not supporting other architectures than x86_64 / amd64
    if  [ "$extension_name" = 'newrelic' ] && [ "$(uname -m)" != x86_64 ]; then
        echo ' skipped'
        continue
    fi

    if ! ./enable.sh "$extension_name" > /tmp/ext-install.log 2>&1; then
        echo ' failure'
        cat /tmp/ext-install.log
        exit 1
    fi

    # These extensions aren't enabled by default
    if [ "$extension_name" = 'blackfire' ] || [ "$extension_name" = "newrelic" ] || [ "$extension_name" = 'tideways' ]; then
        echo ' success'
        continue
    fi
    if [ "$extension_name" = "opcache" ]; then
        extension_name='Zend OPcache'
    fi
    if php -m | grep -i -q "^$extension_name\$"; then
        echo ' success'
        continue
    fi
    echo ' failure'
    echo "Could not find extension in php module list:"
    php -m
    exit 1
done

after="$(php -m)$(php -v)"
echo "After: $after\nDiff:"
diff -u <(echo "$before") <(echo "$after") || true
