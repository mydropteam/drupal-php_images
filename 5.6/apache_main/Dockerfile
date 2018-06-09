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
  gnupg \
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
  uploadprogress-1.0.3.1 \
  memcache-3.0.8 \
  yaml-1.2.0 \
  mongo

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

# SASS and Compass installation
RUN gem install sass compass &&\

# Installation node.js
  curl -sL https://deb.nodesource.com/setup_6.x | sudo bash - && \
  DEBIAN_FRONTEND=noninteractive apt-get -yq --no-install-recommends install -y nodejs; \

# Installation of LESS
  npm update -g npm &&\
  npm install -g less && npm install -g less-plugin-clean-css; \

# Installation of Grunt
  npm install -g grunt-cli; \

# Installation of Gulp
  npm install -g gulp; \

# Installation fo Bower
  npm install -g bower

# Installation of Composer
  RUN cd /usr/src && curl -sS http://getcomposer.org/installer | php -- --version=1.3.1 &&\
  cd /usr/src && mv composer.phar /usr/bin/composer; \

# Installation of drush
  git clone https://github.com/drush-ops/drush.git /usr/local/src/drush &&\
  cd /usr/local/src/drush && git checkout 8.1.6 &&\
  ln -s /usr/local/src/drush/drush /usr/bin/drush &&\
  cd /usr/local/src/drush && composer update && composer install

# Installation of Console
RUN curl https://drupalconsole.com/installer -L -o drupal.phar &&\
  mv drupal.phar /usr/local/bin/drupal &&\
  chmod +x /usr/local/bin/drupal

# Installation of PHP_CodeSniffer with Drupal coding standards.
# See https://www.drupal.org/node/1419988#coder-composer
  RUN composer global require drupal/coder &&\
  ln -s ~/.composer/vendor/bin/phpcs /usr/local/bin &&\
  ln -s ~/.composer/vendor/bin/phpcbf /usr/local/bin &&\
  phpcs --config-set installed_paths ~/.composer/vendor/drupal/coder/coder_sniffer

# Installation of xdebug
  RUN pecl install xdebug-2.5.5 &&\
  echo 'zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20131226/xdebug.so' >> /usr/local/etc/php/php.ini &&\
  touch /usr/local/etc/php/conf.d/xdebug.ini &&\
    echo xdebug.remote_enable=1 >> /usr/local/etc/php/conf.d/xdebug.ini &&\
    echo xdebug.remote_autostart=0 >> /usr/local/etc/php/conf.d/xdebug.ini &&\
    echo xdebug.remote_connect_back=0 >> /usr/local/etc/php/conf.d/xdebug.ini &&\
    echo xdebug.remote_port=9000 >> /usr/local/etc/php/conf.d/xdebug.ini &&\
    echo xdebug.remote_host=docker_host >> /usr/local/etc/php/conf.d/xdebug.ini &&\
    echo xdebug.remote_log=/tmp/php5-xdebug.log >> /usr/local/etc/php/conf.d/xdebug.ini

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

# Installation PHPMD
RUN composer global require phpmd/phpmd &&\
  ln -s ~/.composer/vendor/bin/phpmd /usr/local/bin

# install phpmetrics
RUN wget https://github.com/phpmetrics/PhpMetrics/raw/master/build/phpmetrics.phar &&\
  chmod +x phpmetrics.phar &&\
  mv phpmetrics.phar /usr/local/bin/phpmetrics

# Our apache volume
VOLUME /var/www/html

# ssh keys
RUN mkdir /var/www/.ssh/
RUN chown -R www-data:www-data /var/www/.ssh/
RUN chmod 600 /var/www/.ssh/

# Expose 80 for apache, 9000 for xdebug
EXPOSE 80 9000

# Set a custom entrypoint.
COPY core/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
