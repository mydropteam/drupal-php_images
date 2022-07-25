FROM dropteam/drupal-php:8.1-prod

RUN apt-get update && \
    apt-get install -y \
    git vim curl build-essential sudo ruby-dev rubygems wget

COPY config/php.ini /usr/local/etc/php/

# Install node
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq --no-install-recommends install -y nodejs

## install nvm
RUN git clone https://github.com/creationix/nvm.git /opt/nvm
RUN mkdir /usr/local/nvm
ADD ./config/.bashrc /root/.bashrc

# SASS and Compass installation
RUN gem install sass
RUN gem install compass

# Installation of LESS
RUN npm install -g less && npm install -g less-plugin-clean-css

# Installation of Grunt
RUN npm install -g grunt-cli

# Installation of Gulp
RUN npm install -g gulp

# Installation fo Bower
RUN npm install -g bower

# Install xdebug. We need at least 2.4 version to have PHP 7 support.
#RUN cd /tmp/ && wget http://xdebug.org/files/xdebug-2.6.0RC2.tgz && tar -xvzf xdebug-2.6.0RC2.tgz && cd xdebug-2.6.0RC2/ && phpize && ./configure --enable-xdebug --with-php-config=/usr/local/bin/php-config && make && make install
#RUN cd /tmp/xdebug-2.6.0RC2 && cp modules/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/
RUN pecl install xdebug
RUN echo 'zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20170718/xdebug.so' >> /usr/local/etc/php/php.ini
RUN touch /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo xdebug.remote_enable=1 >> /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo xdebug.remote_autostart=0 >> /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo xdebug.remote_connect_back=1 >> /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo xdebug.remote_port=9000 >> /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo xdebug.remote_log=/tmp/php5-xdebug.log >> /usr/local/etc/php/conf.d/xdebug.ini

# Installation of PHP_CodeSniffer with Drupal coding standards.
# See https://www.drupal.org/node/1419988#coder-composer
RUN composer global require drupal/coder
RUN ln -s ~/.composer/vendor/bin/phpcs /usr/local/bin
RUN ln -s ~/.composer/vendor/bin/phpcbf /usr/local/bin
RUN phpcs --config-set installed_paths ~/.composer/vendor/drupal/coder/coder_sniffer

# installation of ssmtp
RUN DEBIAN_FRONTEND=noninteractive apt-get install --fix-missing -y msmtp && rm -r /var/lib/apt/lists/*
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

RUN a2enmod rewrite expires

# Installation PHPMD
RUN composer global require phpmd/phpmd
RUN ln -s ~/.composer/vendor/bin/phpmd /usr/local/bin

# Our apache volume
VOLUME /var/www/html

# ssh keys
RUN mkdir /var/www/.ssh/
RUN chown -R www-data:www-data /var/www/.ssh/
RUN chmod 600 /var/www/.ssh/

# Expose 80 for apache, 9000 for xdebug
EXPOSE 80 9000