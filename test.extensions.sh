#!/bin/bash

set -e

cd /root/installer/

alias version_compare=dpkg --compare-versions

before="$(php -m)$(php -v)"
echo "Before: $before"

for extension in extensions/*; do
    echo -n "Installing ${extension}..."
    extension_name="${extension%.sh}"
    extension_name="${extension_name#extensions/}"

    # These extensions aren't compiled for PHP 5.6
    if  [ "$extension_name" = 'mongodb' ] && version_compare "$PHP_VERSION" lt 7.0; then
        echo ' skipped'
        continue
    fi
    # Sodium only available for PHP 7.2+
    if  [ "$extension_name" = 'sodium' ] && version_compare "$PHP_VERSION" lt 7.2; then
        echo ' skipped'
        continue
    fi
    # Some extensions only available for PHP <8.0
    if  [[ "$extension_name" = 'protobuf' || "$extension_name" = 'ssh2' ]] && version_compare "$PHP_VERSION" ge 8.0; then
        echo ' skipped'
        continue
    fi

    # Some extensions only available for PHP <8.1
    if  [[ "$extension_name" = 'mcrypt' ]] && version_compare "$PHP_VERSION" ge 8.1; then
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
