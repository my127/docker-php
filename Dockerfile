# syntax=docker/dockerfile:1.4
ARG VERSION
ARG BASEOS
# The redis version is only used in the console image but needs a default value to avoid failing base image
ARG REDIS_VERSION=invalid
FROM php:${VERSION}-fpm-${BASEOS} as base

# Base Packages
# ---
ARG BASEOS
ENV IMAGE_TYPE=base
RUN <<EOF
  set -o errexit
  set -o nounset

  echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends
  echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends
  apt-get update -qq
  apt-get upgrade -qq -y
  # package dependencies
  DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
    ca-certificates \
    curl \
    gettext-base \
    iproute2 \
    msmtp \
    openssl \
    supervisor
  # clean
  apt-get remove dirmngr gnupg2 -qq -y
  apt-get auto-remove -qq -y
  apt-get clean
  rm -rf /var/lib/apt/lists/*
  curl --fail --silent --location --output /sbin/tini "https://github.com/krallin/tini/releases/download/v0.19.0/tini-$(dpkg --print-architecture)"
  chmod +x /sbin/tini
  if ! [ "$(uname -m)" = aarch64 ]; then
    curl --fail --silent --location --output /usr/local/bin/mhsendmail "https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_$(dpkg --print-architecture)"
    chmod +x /usr/local/bin/mhsendmail
  fi
EOF

# PHP
# ---
COPY --link installer/base /root/installer
COPY --link "installer/$BASEOS" /root/installer
RUN cd /root/installer; ./precompile.sh
RUN cd /root/installer; ./enable.sh \
  bcmath \
  gd \
  intl \
  opcache \
  pdo_mysql \
  pdo_pgsql \
  pgsql \
  soap \
  xdebug \
  xsl \
  zip \
 && ./reenable.sh \
   sodium

# App
# ---
ENV PATH "$PATH:/app/bin"
WORKDIR /app

FROM redis:${REDIS_VERSION}-${BASEOS} as redis

FROM base as console
# upstream is SIGQUIT, cli should be SIGTERM
STOPSIGNAL SIGTERM

ARG BASEOS
ARG COMPOSER_VERSION
ARG NODE_VERSION
ENV IMAGE_TYPE=console
RUN <<EOF
  set -o errexit
  set -o nounset

  echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends
  echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends
  apt-get update -qq
  for i in $(seq 1 8); do
    mkdir -p "/usr/share/man/man$i"
  done

  # package dependencies
  DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
    autoconf \
    automake \
    build-essential \
    ca-certificates \
    curl \
    default-mysql-client \
    gettext-base \
    git \
    iproute2 \
    jq \
    libmariadb3 \
    nano \
    nasm \
    openssh-client \
    patch \
    postgresql-client \
    pv \
    rsync \
    unzip \
    wget
  # clean
  apt-get auto-remove -qq -y
  apt-get clean
  rm -rf /var/lib/apt/lists/*
  for i in $(seq 1 8);
    do rm -rf "/usr/share/man/man$i";
  done

  # User: build
  # -----------
  groupadd --gid 1000 build
  useradd --uid 1000 --gid build --shell /bin/bash --create-home build

  # Tool: composer
  # --------------
  curl --fail --silent --show-error --location --retry 3 --output /tmp/composer-installer.php --url https://raw.githubusercontent.com/composer/getcomposer.org/385045ba212b5b73c1710fe6228ef024007d0a73/web/installer
  php -r '
    $signature = "c8b085408188070d5f52bcfe4ecfbee5f727afa458b2573b8eaaf77b3419b0bf2768dc67c86944da1544f06fa544fd47";
    $hash = hash("sha384", file_get_contents("/tmp/composer-installer.php"));
    if (!hash_equals($signature, $hash)) {
        unlink("/tmp/composer-installer.php");
        echo "Integrity check failed, installer is either corrupt or worse." . PHP_EOL;
        exit(1);
    }'
  php /tmp/composer-installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version="$COMPOSER_VERSION"
  rm /tmp/composer-installer.php
EOF

COPY --link --from=redis /usr/local/bin/redis-cli /usr/local/bin/redis-cli

ENV NVM_DIR /home/build/.nvm
USER build
RUN <<EOF
  set -o errexit
  set -o nounset

  # Tool: frontend - nvm, node, npm, yarn
  # -------------------------------------
  cd /home/build
  mkdir .nvm
  curl --fail --silent --show-error --location --output /tmp/nvm.sh https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh
  bash /tmp/nvm.sh
  rm /tmp/nvm.sh

  if [ "${NODE_VERSION:-}" ]; then
    set +o nounset
    . /home/build/.nvm/nvm.sh
    nvm install "${NODE_VERSION}"
    nvm cache clear
    npm install -g yarn
    npm cache clear --force
    set -o nounset
  fi

  # Tool: composer
  # ----------------------------------
  # workaround to make 'composer global remove ...' not fail when it can't fine this file
  mkdir ~/.composer
  echo '{}' > ~/.composer/composer.json
EOF

USER root
