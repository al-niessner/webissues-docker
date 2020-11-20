FROM php:5.6-fpm-alpine

RUN apk add --no-cache \
		bash \
		sed

# install the PHP extensions we need
RUN set -ex; \
	\
	apk add --no-cache --virtual .build-deps \
		libjpeg-turbo-dev \
		libpng-dev \
	; \
	\
	docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
	docker-php-ext-install gd mysqli opcache; \
	\
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --virtual .wordpress-phpexts-rundeps $runDeps; \
	apk del .build-deps

# set recommended PHP.ini settings:q!
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=2'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

VOLUME /var/www/html

ARG APP_VERSION="2.0.1"
ENV CHK_INSTALL data/sites/default/config.inc.php 

RUN mkdir -p /usr/src/app && \
    curl -o app.tar.gz -fSL https://github.com/mimecorg/webissues/releases/download/v${APP_VERSION}/webissues-server-${APP_VERSION}.tar.gz && \
    tar -xzvf app.tar.gz -C /usr/src/app --strip=1 && \
    chown -R www-data:www-data /usr/src/app

RUN mkdir -p /etc/nginx/conf.d
COPY nginx.conf /etc/nginx/conf.d
VOLUME /etc/nginx/conf.d


COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]

