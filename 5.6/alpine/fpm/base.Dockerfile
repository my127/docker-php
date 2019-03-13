FROM php:5.6-fpm-alpine

RUN apk --update add \
  # package dependencies \
    bash \
    freetype \
    icu \
    iproute2 \
    libjpeg-turbo \
    libmcrypt \
    libpng \
    libxml2 \
    libxslt \
    shadow \
    supervisor \
  # package dependencies only needed for the duration of the build \
    autoconf \
    freetype-dev \
    g++ \
    icu-dev \
    libjpeg-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libxml2-dev \
    libxslt-dev \
    make \
    openssl-dev \
  # php extensions \
    && docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install \
      bcmath \
      gd \
      intl \
      mcrypt \
      opcache \
      pdo_mysql \
      soap \
      xsl \
      zip \
    && printf "\n" | pecl install xdebug-2.5.5 && docker-php-ext-enable xdebug \
  # clean \
    && apk del \
    autoconf g++ make freetype-dev libjpeg-turbo-dev libpng-dev openssl-dev libxml2-dev libmcrypt-dev libxslt-dev icu-dev \
    && rm -rf /var/cache/apk/*

# app
# ---
ENV PATH "$PATH:/app/bin"
WORKDIR /app
