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

    # These extensions aren't compiled for PHP 5.6
    if  [ "$extension_name" = 'mongodb' ] && [ "$VERSION" -lt 70 ]; then
        echo ' skipped'
        continue
    fi
    # Sodium only available for PHP 7.2+
    if  [ "$extension_name" = 'sodium' ] && [ "$VERSION" -lt 72 ]; then
        echo ' skipped'
        continue
    fi
    # Some extensions only available for PHP <8.0
    if  [[ "$extension_name" = 'event' || "$extension_name" = 'mcrypt' || "$extension_name" = 'protobuf' || "$extension_name" = 'rdkafka' || "$extension_name" = 'ssh2' || "$extension_name" = 'xmlrpc' ]] && [ "$VERSION" -ge 80 ]; then
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
