ARG VERSION=7.3
ARG BASEOS=stretch
FROM my127/php:${VERSION}-fpm-${BASEOS}

ARG BASEOS=stretch
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
   default-mysql-client \
   gettext-base \
   git \
   iproute2 \
   jq \
   nano \
   nasm \
   openssh-client \
   patch \
   pv \
   rsync \
   unzip \
   wget \
  # clean \
 && apt-get auto-remove -qq -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

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
RUN curl --silent --fail --location --retry 3 --output /tmp/installer.php --url https://raw.githubusercontent.com/composer/getcomposer.org/b5a70434f0f582468a7824418553defaf67d5299/web/installer \
 && php -r " \
    \$signature = 'c5b9b6d368201a9db6f74e2611495f369991b72d9c8cbd3ffbc63edff210eb73d46ffbfce88669ad33695ef77dc76976'; \
    \$hash = hash('sha384', file_get_contents('/tmp/installer.php')); \
    if (!hash_equals(\$signature, \$hash)) { \
        unlink('/tmp/installer.php'); \
        echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
        exit(1); \
    }" \
 && php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=1.9.3

# Tool: composer > hirak/prestissimo
# ----------------------------------
# enables parallel downloading of composer depedencies and massively speeds up the
# time it takes to run composer install.
USER build
RUN composer global require hirak/prestissimo
USER root
