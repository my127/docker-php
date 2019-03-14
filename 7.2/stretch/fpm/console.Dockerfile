FROM my127/php:7.2-fpm-stretch

RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
  # package dependencies \
   autoconf \
   automake \
   build-essential \
   ca-certificates \
   curl \
   git \
   iproute2 \
   mysql-client \
   nano \
   nasm \
   patch \
   rsync \
   wget \
   zip \
   zlib1g-dev \
  # clean \
 && apt-get auto-remove -qq -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# user: build
# -----------
RUN groupadd --gid 1000 build \
 && useradd --uid 1000 --gid build --shell /bin/bash --create-home build

# tool: frontend - nvm, node, npm, yarn
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

# tool: composer
# --------------
RUN curl --silent --fail --location --retry 3 --output /tmp/installer.php --url https://raw.githubusercontent.com/composer/getcomposer.org/cb19f2aa3aeaa2006c0cd69a7ef011eb31463067/web/installer \
 && php -r " \
    \$signature = '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5'; \
    \$hash = hash('sha384', file_get_contents('/tmp/installer.php')); \
    if (!hash_equals(\$signature, \$hash)) { \
        unlink('/tmp/installer.php'); \
        echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
        exit(1); \
    }" \
 && php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=1.8.4

# tool: composer > hirak/prestissimo
# ----------------------------------
# enables parallel downloading of composer depedencies and massively speeds up the
# time it takes to run composer install.
USER build
RUN composer global require hirak/prestissimo
USER root
