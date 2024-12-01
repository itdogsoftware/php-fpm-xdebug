FROM php:8.3.14-fpm-bullseye

LABEL authors = "Roy To <roy.to@itdogsoftware.co>"
# Install library & necessary service
RUN apt-get update && apt-get install -y libzip-dev zip libpng-dev cron vim gettext-base unzip git && rm -rf /var/lib/apt/lists/*
# Install docker php extensions
RUN pecl channel-update pecl.php.net && pecl install redis xdebug-3.3.0 && docker-php-ext-enable redis
RUN docker-php-ext-install mysqli 
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install opcache
RUN docker-php-ext-install zip
RUN docker-php-ext-install gd
RUN docker-php-ext-install sockets
RUN docker-php-ext-install pcntl
RUN echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20230831/xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini
RUN echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini
RUN echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

# set production config
RUN mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
# Update php config
RUN sed -i "/memory_limit\s=\s/s/=.*/= 512M/" /usr/local/etc/php/php.ini

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
EXPOSE 9000
