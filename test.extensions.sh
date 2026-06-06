#!/bin/bash

set -e

cd /root/installer/

source ./lib/functions.sh

before="$(php -m)$(php -v)"
echo "Before: $before"

mapfile -t available_extensions < <(list_available)
for extension in "${available_extensions[@]}"; do
    echo -n "Installing ${extension}..."

    # NewRelic PHP agent is currently not supporting other architectures than x86_64 / amd64
    if  [ "$extension" = 'newrelic' ] && [ "$(uname -m)" != x86_64 ]; then
        echo ' skipped'
        continue
    fi

    if ! ./enable.sh "$extension" > /tmp/ext-install.log 2>&1; then
        echo ' failure'
        cat /tmp/ext-install.log
        exit 1
    fi

    # These extensions aren't enabled by default
    if [ "$extension" = 'blackfire' ] || [ "$extension" = "newrelic" ] || [ "$extension" = 'tideways' ]; then
        echo ' success'
        continue
    fi
    if [ "$extension" = "opcache" ]; then
        extension='Zend OPcache'
    fi
    if php -m | grep -i -q "^$extension\$"; then
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
