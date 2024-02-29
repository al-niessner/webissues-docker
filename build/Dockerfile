FROM php:7.4-apache
RUN apt-get update \
  && apt-get install -y libonig-dev libpq-dev libc-client-dev libkrb5-dev \
  && rm -r /var/lib/apt/lists/* \
  && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
  && docker-php-ext-install imap \
  && docker-php-ext-install mysqli \
  && docker-php-ext-install mbstring \
  && a2enmod rewrite \
  && service apache2 restart

ARG APP_VERSION="2.0.5"
RUN  curl -fSL https://github.com/mimecorg/webissues/releases/download/v${APP_VERSION}/webissues-server-${APP_VERSION}.tar.gz | tar xzv --strip=1
RUN  mv system/bootstrap.inc.php system/bootstrap.inc.php-orig
COPY ./bootstrap.inc.php system/bootstrap.inc.php
RUN  chown -R www-data:www-data . 

