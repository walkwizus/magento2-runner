FROM php:7.2-apache
LABEL company="Wakwizus"
LABEL maintainer="jimmy@walkwizus.fr"
RUN apt-get update && apt-get install -y \
        cron \
        git \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libxml2-dev \
        libxslt1-dev \
        libicu-dev \
        mariadb-client \
        xmlstarlet \
        libcurl4-openssl-dev \
        pkg-config \
        libssl-dev \
        libbz2-dev \
	libsodium-dev \	
    && docker-php-ext-install -j$(nproc) bcmath \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) json \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-install -j$(nproc) mbstring \
    && docker-php-ext-install -j$(nproc) pcntl \
    && docker-php-ext-install -j$(nproc) soap \
    && docker-php-ext-install -j$(nproc) xsl \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-install -j$(nproc) pdo \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) bz2 \
    && pecl install redis-4.2.0 \
    && pecl install libsodium-2.0.21 \
    && docker-php-ext-enable redis \
    && a2enmod rewrite headers \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin/ --filename=composer \
    && php -r "unlink('composer-setup.php');" \
    && composer global require hirak/prestissimo
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g grunt-cli
COPY etc/php.ini /usr/local/etc/php/conf.d/00_magento.ini
COPY etc/apache.conf /etc/apache2/conf-enabled/00_magento.conf
WORKDIR /var/www/html/
