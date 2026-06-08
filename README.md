# PHP Images

## Contents

- [Base](#base)
- [Console](#console)
- [Supported Versions](#supported-versions)
- [Build and Test](#build-and-test)

## Base

A starting point with some common extensions for running various frameworks and applications.

<!-- markdownlint-disable MD024 -->

### Packages

- php-bcmath
- php-gd
- php-intl
- php-mcrypt
- php-opcache
- php-pdo (mysql)
- php-soap
- php-xdebug
- php-xsl
- php-zip

## Console

Used in development for building and interacting with the application with a familiar set of tools, can also be used as part of a multi-stage build docker image.

### Packages

- build-tools (autoconf, automake, g++, gcc, make, nasm)
- composer (1.10.27 or 2.7.2)
- curl
- gettext-base
- git
- iproute
- mysql (client)
- nano
- nvm
- node (lts/dubnium aka v10, or none for PHP 8.3+)
- npm
- patch
- redis-cli
- rsync
- wget
- yarn (if node is installed)
- zip

## Supported Versions

| PHP version | Bullseye | Bookworm | Trixie |
| ----------- | -------- | -------- | ------ |
| `8.2`       | x        | x        |
| `8.3`       |          | x        | x      |
| `8.4`       |          | x        | x      |

## Build and Test

Build and test all Trixie images:

```bash
BUILD=trixie ./build.sh
BUILD=trixie ./test.sh
docker image rm \
  my127/php:8.3-fpm-trixie \
  my127/php:8.3-fpm-trixie-console \
  my127/php:8.4-fpm-trixie \
  my127/php:8.4-fpm-trixie-console
```

Build and test all PHP 8.4 images:

```bash
BUILD=php84 ./build.sh
BUILD=php84 ./test.sh
docker image rm \
  my127/php:8.4-fpm-bookworm \
  my127/php:8.4-fpm-bookworm-console \
  my127/php:8.4-fpm-trixie \
  my127/php:8.4-fpm-trixie-console
```

Build and test a single image:

```bash
BUILD=php84-fpm-trixie-console ./build.sh
BUILD=php84-fpm-trixie-console ./test.sh
```

Remove locally built images when finished:

```bash
docker image rm my127/php:8.4-fpm-trixie-console
```
