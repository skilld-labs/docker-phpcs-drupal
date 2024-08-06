FROM alpine:3.20

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.schema-version="1.0" \
  org.label-schema.name="docker-phpcs-drupal" \
  org.label-schema.description="PHP codesniffer for Drupal - phpcs & phpcbf" \
  org.label-schema.vcs-url="https://github.com/skilld-labs/docker-phpcs-drupal" \
  maintainer="Andriy Yun , Andy Postnikov , Sergey Orlov"

RUN set -e \
  && apk add --no-cache \
  curl \
  git \
  patch \
  php83 \
  php83-apcu \
  php83-ctype \
  php83-json \
  php83-mbstring \
  php83-opcache \
  php83-openssl \
  php83-phar \
  php83-simplexml \
  php83-tokenizer \
  php83-xmlwriter \
  php83-zlib;

RUN ln -s $(which php8) /usr/local/bin/php \
  && curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/bin \
  && composer global config --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true \
  && composer global require drupal/coder --update-no-dev --no-suggest --prefer-dist ^8.3 \
  && composer global require squizlabs/php_codesniffer \
  && ln -s /root/.composer/vendor/bin/phpcs /usr/bin/phpcs \
  && ln -s /root/.composer/vendor/bin/phpcbf /usr/bin/phpcbf \
  # Clone coder sniffs into the codesniffer sniffs directory.
  && ln -s /root/.composer/vendor/drupal/coder/coder_sniffer/Drupal /root/.composer/vendor/squizlabs/php_codesniffer/src/Standards/Drupal \
  && ln -s /root/.composer/vendor/drupal/coder/coder_sniffer/DrupalPractice /root/.composer/vendor/squizlabs/php_codesniffer/src/Standards/DrupalPractice \
  # Removing packages which needed only during the installation.
  && apk del --no-cache git \
  # Clear composer cache - it will just take space.
  && rm -rf /root/.composer/cache/* \
  # Sniffs could take much time, we will set unlimited time for PHP execution
  && sed -i "s/.*memory_limit = .*/memory_limit = -1/" /etc/php83/php.ini

VOLUME /work
WORKDIR /work

CMD ["phpcs", "--standard=Drupal,DrupalPractice", "."]
