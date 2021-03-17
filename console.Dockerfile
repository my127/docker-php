ARG VERSION=7.3
ARG BASEOS=stretch
ARG REDIS_VERSION=6.2

FROM redis:${REDIS_VERSION}-${BASEOS} as redis

FROM my127/php:${VERSION}-fpm-${BASEOS}
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
 && curl -o /tmp/nvm-install.sh https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh \
 && bash /tmp/nvm-install.sh \
 && rm /tmp/nvm-install.sh \
 && . /home/build/.nvm/nvm.sh \
 && nvm install lts/dubnium \
 && npm install -g yarn
USER root

# Tool: composer
# --------------
RUN curl --silent --fail --location --retry 3 --output /tmp/installer.php --url https://raw.githubusercontent.com/composer/getcomposer.org/fb07bd70d93cf733c1c94aef7fc68502f81aca2b/web/installer \
 && php -r " \
    \$signature = '8a6138e2a05a8c28539c9f0fb361159823655d7ad2deecb371b04a83966c61223adc522b0189079e3e9e277cd72b8897'; \
    \$hash = hash('sha384', file_get_contents('/tmp/installer.php')); \
    if (!hash_equals(\$signature, \$hash)) { \
        unlink('/tmp/installer.php'); \
        echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
        exit(1); \
    }" \
 && php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=1.10.17

# Tool: composer > hirak/prestissimo
# ----------------------------------
# enables parallel downloading of composer depedencies and massively speeds up the
# time it takes to run composer install.
USER build
RUN composer global require hirak/prestissimo
USER root
