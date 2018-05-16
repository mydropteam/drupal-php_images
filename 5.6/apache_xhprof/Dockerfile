# Pull base image.
FROM php:5.6-apache

COPY config/php.ini /usr/local/etc/php/

# ADD BASHRC CONFIG
COPY config/bashrc /root/
RUN mv /root/bashrc /root/.bashrc

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
  libpng12-dev \
  libjpeg62-turbo-dev \
  libmcrypt-dev \
  libssl-dev \
  libxml2-dev \
  libxslt1-dev \
  libyaml-dev \
  linux-libc-dev \
  memcached \
  mysql-client \
  nano \
  ruby-dev \
  rubygems \
  sudo \
  tree \
  vim \
  wget \
  zip

  # Install PECL packages
  COPY docker-php-pecl-install /usr/local/bin/
  RUN chmod +x /usr/local/bin/docker-php-pecl-install
  RUN docker-php-pecl-install \
    memcache-3.0.8 \
    mongo \
    uploadprogress-1.0.3.1 \
    xhprof-0.9.4 \
    yaml-1.2.0

RUN docker-php-ext-configure gd --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install \
  calendar \
  exif \
  gd \
  ftp \
  intl \
  mbstring \
  mcrypt \
  mysql \
  mysqli \
  opcache \
  pdo_mysql \
  soap \
  xsl \
  zip

COPY core/memcached.conf /etc/memcached.conf

# Installation node.js
  RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo bash - &&\
  DEBIAN_FRONTEND=noninteractive apt-get -yq --no-install-recommends install -y nodejs

# Installation of Composer
  RUN cd /usr/src && curl -sS http://getcomposer.org/installer | php -- --version=1.3.1 &&\
  cd /usr/src && mv composer.phar /usr/bin/composer

# Installation of drush
  RUN git clone https://github.com/drush-ops/drush.git /usr/local/src/drush &&\
  cd /usr/local/src/drush && git checkout 8.1.6 &&\
  ln -s /usr/local/src/drush/drush /usr/bin/drush &&\
  cd /usr/local/src/drush && composer update && composer install

# Installation of Console
RUN curl https://drupalconsole.com/installer -L -o drupal.phar &&\
  mv drupal.phar /usr/local/bin/drupal &&\
  chmod +x /usr/local/bin/drupal

# Installation of xhgui
RUN git clone https://github.com/perftools/xhgui.git /var/www/xhgui &&\
  chmod -R 0777 /var/www/xhgui/cache &&\
  cd /var/www/xhgui/ &&\
  php install.php
RUN sed -i -e '$a [xhgui] auto_prepend_file = "/var/www/xhgui/external/header.php"' \
  /usr/local/etc/php/php.ini

COPY core/xhgui/config.php /var/www/xhgui/config/


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

RUN a2enmod rewrite expires &&\
  service apache2 restart

# Our apache volume
VOLUME /var/www/html

# Expose 80 for apache
EXPOSE 80

# Set a custom entrypoint.
COPY core/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
