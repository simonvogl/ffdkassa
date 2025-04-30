FROM dunglas/frankenphp
ENV SERVER_NAME=:80
#install php extentions
RUN install-php-extensions \
        mysqli \
        pdo_mysql \
        ftp \
        gd \
        curl \
        zip \
        xml
#copy php.ini
COPY ./php.ini /usr/local/etc/php/php.ini
