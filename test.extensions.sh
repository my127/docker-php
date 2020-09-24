#!/bin/bash

set -e

cd /root/installer/

VERSION="$(echo "$PHP_VERSION" | cut -c 1,3)"

before="$(php -m)$(php -v)"
echo "Before: $before"

for extension in extensions/*; do
    echo -n "Installing ${extension}..."
    extension_name="${extension%.sh}"
    extension_name="${extension_name#extensions/}"
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
    # Sodium only available for PHP 7.2+
    if  [ "$extension_name" = 'sodium' ] && [ "$VERSION" -lt 72 ]; then
        echo ' success'
        continue
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
