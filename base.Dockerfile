ARG VERSION=7.3
FROM php:${VERSION}-fpm-stretch

# Base Packages
# ---
RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
  # package dependencies \
   ca-certificates \
   iproute2 \
   supervisor \
  # clean \
 && apt-get auto-remove -qq -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# PHP
# ---
COPY installer/stretch /root/installer
RUN cd /root/installer; ./enable.sh \
  bcmath \
  gd \
  intl \
  mcrypt \
  opcache \
  pdo_mysql \
  soap \
  xdebug \
  xsl \
  zip

# App
# ---
ENV PATH "$PATH:/app/bin"
WORKDIR /app
