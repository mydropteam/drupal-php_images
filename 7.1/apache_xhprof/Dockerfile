# Pull base image.
FROM php:7.4.28-apache

COPY config/php.ini /usr/local/etc/php/

# ADD BASHRC CONFIG
COPY config/bashrc /root/
RUN mv /root/bashrc /root/.bashrc

RUN apt-get update && apt-get install --fix-missing wget gnupg -y
RUN echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list
RUN echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list
RUN cd /tmp && wget https://www.dotdeb.org/dotdeb.gpg && apt-key add dotdeb.gpg

RUN apt-get update && apt-get install --fix-missing -y \
  apt-transport-https \
  apt-utils \
  cloc \
  imagemagick \
  graphviz \
  git \
  libicu-dev \
  libmemcached-tools \
  libmemcached-dev \
  libpng-dev \
  libjpeg62-turbo-dev \
  libmcrypt-dev \
  libssl-dev \
  libxml2-dev \
  libxslt1-dev \
  libyaml-dev \
  linux-libc-dev \
  memcached \
  default-mysql-client \
  nano \
  pkg-config \
  ruby-dev \
  rubygems \
  sudo \
  tree \
  vim \
  wget \
  zip

# Install memcached for PHP 7
RUN cd /tmp && git clone https://github.com/php-memcached-dev/php-memcached.git
RUN cd /tmp/php-memcached && sudo git checkout php7 && phpize && ./configure --disable-memcached-sasl && make && make install
RUN touch /usr/local/etc/php/conf.d/memcached.ini &&\
 echo "extension=/usr/local/lib/php/extensions/no-debug-non-zts-20160303/memcached.so" >> /usr/local/etc/php/conf.d/memcached.ini



RUN chmod +x /usr/local/bin/docker-php-ext-install
RUN docker-php-ext-configure gd --with-jpeg-dir=/usr/include/ \
&& docker-php-ext-install \
  calendar \
  exif \
  gd \
  intl \
  mbstring \
  mcrypt \
  opcache \
  pdo_mysql \
  soap \
  xsl \
  zip

# Install PECL packages
RUN pecl install \
  mongodb \
&& docker-php-ext-enable \
  mongodb

COPY core/memcached.conf /etc/memcached.conf

# Installation node.js
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo bash -
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq --no-install-recommends install -y nodejs

RUN \
cd /tmp && git clone https://github.com/tideways/php-profiler-extension.git && cd /tmp/php-profiler-extension && phpize && ./configure && make && make install; \
echo "extension=tideways.so" >> /usr/local/etc/php/php.ini && echo "tideways.auto_prepend_library=0" >> /usr/local/etc/php/php.ini; \

git clone https://github.com/perftools/xhgui.git /var/www/xhgui; \
chmod -R 0777 /var/www/xhgui/cache &&\
cd /var/www/xhgui/ && php install.php &&\
sed -i -e '$a\
[xhgui] \
auto_prepend_file = "/var/www/xhgui/external/header.php"' \
/usr/local/etc/php/php.ini

COPY core/xhgui/config.php /var/www/xhgui/config/

# Installation of Composer
RUN cd /usr/src && curl -sS http://getcomposer.org/installer | php
RUN cd /usr/src && mv composer.phar /usr/bin/composer

RUN rm -rf /var/www/html && \
  mkdir -p /var/lock/apache2 /var/run/apache2 /var/log/apache2 /var/www/html && \
  chown -R www-data:www-data /var/lock/apache2 /var/run/apache2 /var/log/apache2 /var/www

# installation of ssmtp
RUN DEBIAN_FRONTEND=noninteractive apt-get install --fix-missing -y ssmtp && rm -r /var/lib/apt/lists/*
ADD core/ssmtp.conf /etc/ssmtp/ssmtp.conf
ADD core/php-smtp.ini /usr/local/etc/php/conf.d/php-smtp.ini

COPY config/apache2.conf /etc/apache2

# Installation of Opcode cache
RUN ( \
  echo "opcache.memory_consumption=128"; \
  echo "opcache.interned_strings_buffer=8"; \
  echo "opcache.max_accelerated_files=4000"; \
  echo "opcache.revalidate_freq=2"; \
  echo "opcache.fast_shutdown=1"; \
  echo "opcache.enable_cli=1"; \
  ) > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN a2enmod rewrite expires && service apache2 restart

# Our apache volume
VOLUME /var/www/html

# Expose 80 for apache, 9000 for xdebug
EXPOSE 80 9000
