FROM richarvey/nginx-php-fpm

LABEL company="Wakwizus"
LABEL maintenener="Jimmy Carricart <jimmy@walkwizus.fr>"

RUN apk -U upgrade \
    && apk add --no-cache --update --virtual buildDeps autoconf \
    && apk --update add nano \
    && docker-php-ext-install bcmath \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install json \
    && docker-php-ext-install iconv \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install soap \
    && docker-php-ext-install xsl \
    && docker-php-ext-install zip \
    && docker-php-ext-install intl \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin/ --filename=composer \
    && php -r "unlink('composer-setup.php');" \
    && composer global require hirak/prestissimo

WORKDIR /var/www/html/