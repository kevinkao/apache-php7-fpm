FROM ubuntu:16.04

RUN echo "deb http://mirrors.digitalocean.com/ubuntu trusty main multiverse \
    deb http://mirrors.digitalocean.com/ubuntu  trusty-updates main multiverse \
    deb http://security.ubuntu.com/ubuntu  trusty-security main multiverse" \
    >> /etc/apt/sources.list.d/mine.list

RUN apt-get update && apt-get install -y \
        supervisor \
        apache2 \
        libapache2-mod-fastcgi \
        php7.0 \
        php7.0-fpm \
        php7.0-curl \
        php7.0-mcrypt \
        php7.0-mbstring \
        php7.0-mysql \
        php7.0-xml \
        php-redis \
        php-mongodb \
        unzip \
        iputils-ping

COPY conf/site.conf /etc/apache2/sites-available/000-default.conf

RUN mkdir -p /var/log/php-fpm
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN a2enconf php7.0-fpm; \
    a2enmod actions fastcgi alias proxy proxy_fcgi rewrite; \
    service php7.0-fpm start

EXPOSE 80

CMD ["/usr/bin/supervisord"]
