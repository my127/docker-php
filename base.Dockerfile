ARG VERSION=7.3
FROM php:${VERSION}-fpm-stretch

# PHP
# ---
ENV PATH "$PATH:/app/bin"
WORKDIR /app
COPY installer/stretch /root/installer
RUN cd /root/installer; ./enable.sh \
  bcmath \
  gd \
  intl \
  mcrypt \
  opcache \
  pdo_mysql \
  soap \
  xsl \
  zip 

# App
# ---
ENV PATH "$PATH:/app/bin"
WORKDIR /app
