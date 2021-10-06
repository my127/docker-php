ARG VERSION=7.3
ARG BASEOS=stretch
FROM php:${VERSION}-fpm-${BASEOS}

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
