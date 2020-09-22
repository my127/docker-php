#!/bin/bash

set -e

cd /root/installer/

for extension in extensions/*; do
    echo -n "Installing ${extension}..."
    extension_name="${extension%.sh}"
    extension_name="${extension_name#extensions/}"
    if ! ./enable.sh "$extension_name" > /tmp/ext-install.log 2>&1; then
        echo ' failure'
        cat /tmp/ext-install.log
        exit 1
    fi
    if [ "$extension_name" = 'blackfire' ] || [ "$extension" = 'tideways' ]; then
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

php -m
php -v
