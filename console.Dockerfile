# syntax=docker/dockerfile:1.2
ARG VERSION=7.3
ARG BASEOS=stretch
ARG REDIS_VERSION=6.2

FROM redis:${REDIS_VERSION}-${BASEOS} as redis

FROM my127/php:${VERSION}-fpm-${BASEOS}
# upstream is SIGQUIT, cli should be SIGTERM
STOPSIGNAL SIGTERM

ARG BASEOS
ENV IMAGE_TYPE=console
RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
 \
 echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
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
 && curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash \
 && . /home/build/.nvm/nvm.sh \
 && nvm install lts/dubnium \
 && npm install -g yarn
USER root

# Tool: composer
# --------------
RUN --mount=type=cache,target=/usr/local/src \
 curl --silent --fail --location --retry 3 --output /usr/local/src/composer-installer.php --url https://raw.githubusercontent.com/composer/getcomposer.org/9b15acb8cb2cdaf2207f2bff8c0412ede0e7bd5b/web/installer \
 && php -r " \
    \$signature = '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3'; \
    \$hash = hash('sha384', file_get_contents('/tmp/composer-installer.php')); \
    if (!hash_equals(\$signature, \$hash)) { \
        unlink('/tmp/composer-installer.php'); \
        echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
        exit(1); \
    }" \
 && php /usr/local/src/composer-installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=1.10.22

# Tool: composer > hirak/prestissimo
# ----------------------------------
# enables parallel downloading of composer depedencies and massively speeds up the
# time it takes to run composer install.
USER build
RUN composer global require hirak/prestissimo
USER root
