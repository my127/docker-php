ARG VERSION=7.3
ARG BASEOS=stretch
FROM php:${VERSION}-fpm-${BASEOS}

# Base Packages
# ---
ARG BASEOS=stretch
ENV IMAGE_TYPE=base
RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && if [ "$VERSION" != "5.6" ] && [ "$VERSION" != "7.0" ] && [ "$VERSION" != "7.1" ] && [ "$BASEOS" = "stretch" ]; then echo 'deb http://deb.debian.org/debian stretch-backports main' >> /etc/apt/sources.list.d/stetch-backports.list; fi \
 && apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
  # package dependencies \
   ca-certificates \
   gettext-base \
   iproute2 \
   supervisor \
  # clean \
 && apt-get auto-remove -qq -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

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
