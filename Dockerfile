FROM alpine:3.4

MAINTAINER Mahan Hazrati <eng.mahan.hazrati@gmail.com>

ENV NGINX_VERSION 1.11.5

RUN apk update
RUN apk --update add wget \
	curl \
	git \
	grep \
	gmp-dev \
	libmcrypt-dev \
	freetype-dev \
	libxpm-dev \
	libwebp-dev \
	libjpeg-turbo-dev \
	libjpeg \
	bzip2-dev \
	openssl-dev \
	krb5-dev \
	libxml2-dev \
	build-base \
	tar \
	make \
	autoconf

RUN apk --update add re2c bison curl-dev

# install PHP7
ADD compile-php7.sh /

RUN chmod +x ./compile-php7.sh
RUN ./compile-php7.sh

# install nginx
RUN apk add nginx

# install python mysql
RUN apk add mysql

# install supervisord
RUN apk add supervisor

RUN rm -f /var/cache/apk/*

COPY ./confs/supervisord.conf /etc/supervisord.conf
COPY ./confs/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./confs/php/php.ini /etc/php/php.ini
COPY ./confs/php/php-fpm.conf /etc/php/php-fpm.conf
COPY ./confs/mysql/my.cnf /etc/mysql/my.cnf

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]

EXPOSE 80 443
