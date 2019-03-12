FROM php:7.1-fpm-stretch

RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && apt-get update -qq \
 # Install base packages \
 && DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
    apt-transport-https \
    libfreetype6 \
    libicu57 \
    iproute2 \
    libjpeg62-turbo \
    libmcrypt4 \
    libpng16-16 \
    libxml2 \
    libxslt1.1 \
    supervisor \
  # package dependencies only needed for the duration of the build \
    autoconf \
    g++ \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libxml2-dev \
    libxslt1-dev \
    make \
    libssl-dev \
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
    && printf "\n" | pecl install xdebug && docker-php-ext-enable xdebug \
 # Clean the image \
 && DEBIAN_FRONTEND=noninteractive apt-get -y --purge remove \
    autoconf \
    g++ \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libxml2-dev \
    libxslt1-dev \
    make \
    libssl-dev \
 && apt-get auto-remove -qq -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
