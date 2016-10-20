FROM php:7.1.0RC4-fpm-alpine

MAINTAINER Mahan Hazrati <eng.mahan.hazrati@gmail.com>

RUN apk --update add \
    nginx \
    mysql \
    supervisor --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/

RUN rm -f /var/cache/apk/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

ADD ./confs/supervisord.conf /etc/supervisord.conf
ADD ./confs/nginx/nginx.conf /etc/nginx/nginx.conf
ADD ./confs/nginx/default.conf /etc/nginx/sites-enabled/default.conf
ADD ./confs/php/php.ini /etc/php/php.ini
ADD ./confs/mysql/my.cnf /etc/mysql/my.cnf

RUN mkdir /var/run/php/
RUN mkdir -p /tmp/logs/supervisor

CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]

WORKDIR "/var/www"

EXPOSE 80 443 9000
