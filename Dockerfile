ARG VERSION=7.3
ARG BASEOS=stretch
ARG REDIS_VERSION=6.2
FROM php:${VERSION}-fpm-${BASEOS} as base

# Base Packages
# ---
ARG BASEOS=stretch
ENV IMAGE_TYPE=base
RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && if [ "$VERSION" != "5.6" ] && [ "$VERSION" != "7.0" ] && [ "$VERSION" != "7.1" ] && [ "$BASEOS" = "stretch" ]; then \
   apt-get update -qq \
   && echo 'deb http://deb.debian.org/debian stretch-backports main' >> /etc/apt/sources.list.d/stetch-backports.list \
   && DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
    # key receive dependencies \
     dirmngr \
     gnupg2 \
   && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138 0E98404D386FA1D9; \
 fi \
 && apt-get update -qq \
 && apt-get upgrade -qq -y \
 && DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
  # package dependencies \
   ca-certificates \
   curl \
   gettext-base \
   iproute2 \
   msmtp \
   openssl \
   supervisor \
  # clean \
 && apt-get remove dirmngr gnupg2 -qq -y \
 && apt-get auto-remove -qq -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && curl --fail --silent --location --output /sbin/tini https://github.com/krallin/tini/releases/download/v0.19.0/tini \
 && chmod +x /sbin/tini \
 && curl --fail --silent --location --output /usr/local/bin/mhsendmail https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 \
 && chmod +x /usr/local/bin/mhsendmail

# PHP
# ---
COPY installer/stretch /root/installer
COPY "installer/$BASEOS" /root/installer
RUN cd /root/installer; ./precompile.sh \
 && ./enable.sh \
  bcmath \
  gd \
  intl \
  mcrypt \
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
ENV IMAGE_TYPE=console
RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && apt-get update -qq \
 && for i in $(seq 1 8); do mkdir -p "/usr/share/man/man$i"; done \
 && DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
  # package dependencies \
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
   nano \
   nasm \
   openssh-client \
   patch \
   postgresql-client \
   pv \
   rsync \
   unzip \
   wget \
  # clean \
 && apt-get auto-remove -qq -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && for i in $(seq 1 8); do rm -rf "/usr/share/man/man$i"; done

COPY --from=redis /usr/local/bin/redis-cli /usr/local/bin/redis-cli

# User: build
# -----------
RUN groupadd --gid 1000 build \
 && useradd --uid 1000 --gid build --shell /bin/bash --create-home build

# Tool: frontend - nvm, node, npm, yarn
# -------------------------------------
ENV NVM_DIR /home/build/.nvm
USER build
RUN cd /home/build \
 && mkdir .nvm \
 && curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.39.0/install.sh | bash \
 && . /home/build/.nvm/nvm.sh \
 && nvm install 10 \
 && npm install -g yarn
USER root

# Tool: composer
# --------------
RUN curl --silent --fail --location --retry 3 --output /tmp/composer-installer.php --url https://raw.githubusercontent.com/composer/getcomposer.org/9b15acb8cb2cdaf2207f2bff8c0412ede0e7bd5b/web/installer \
 && php -r " \
    \$signature = '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3'; \
    \$hash = hash('sha384', file_get_contents('/tmp/composer-installer.php')); \
    if (!hash_equals(\$signature, \$hash)) { \
        unlink('/tmp/composer-installer.php'); \
        echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
        exit(1); \
    }" \
 && php /tmp/composer-installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=1.10.23 \
 && rm /tmp/composer-installer.php

# Tool: composer > hirak/prestissimo
# ----------------------------------
# enables parallel downloading of composer depedencies and massively speeds up the
# time it takes to run composer install.
USER build
RUN composer global require hirak/prestissimo
USER root
