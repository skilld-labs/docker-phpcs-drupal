FROM alpine:3.20

ARG PHP=php83
ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.schema-version="1.0" \
  org.label-schema.name="docker-phpcs-drupal" \
  org.label-schema.description="PHP codesniffer for Drupal - phpcs & phpcbf" \
  org.label-schema.vcs-url="https://github.com/skilld-labs/docker-phpcs-drupal" \
  maintainer="Andriy Yun, Andy Postnikov, Sergey Orlov"

RUN set -e \
  && apk upgrade --update-cache -a && apk add \
  curl \
  git \
  patch \
  ${PHP} \
  ${PHP}-apcu \
  ${PHP}-ctype \
  ${PHP}-json \
  ${PHP}-mbstring \
  ${PHP}-opcache \
  ${PHP}-openssl \
  ${PHP}-phar \
  ${PHP}-simplexml \
  ${PHP}-tokenizer \
  ${PHP}-xmlwriter \
  ${PHP}-zip \
  && rm -fr /var/cache/apk/* \
  && ln -fs $(which ${PHP}) /usr/bin/php \
  && curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/bin \
  && composer global config --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true \
  && composer global require drupal/coder -o --apcu-autoloader --update-no-dev --no-suggest --prefer-dist ^8.3 \
  && ln -s /root/.composer/vendor/bin/phpcs /usr/bin/phpcs \
  && ln -s /root/.composer/vendor/bin/phpcbf /usr/bin/phpcbf \
  # Link coder sniffs into the codesniffer sniffs directory.
  && ln -s /root/.composer/vendor/drupal/coder/coder_sniffer/Drupal /root/.composer/vendor/squizlabs/php_codesniffer/src/Standards/Drupal \
  && ln -s /root/.composer/vendor/drupal/coder/coder_sniffer/DrupalPractice /root/.composer/vendor/squizlabs/php_codesniffer/src/Standards/DrupalPractice \
  # Removing packages which needed only during the installation.
  && apk del --no-network --purge git \
  # Clear composer cache - it will just take space.
  && rm -rf /root/.composer/cache/* \
  # Sniffs could take memory, set unlimited to be customized by end-user
  && sed -i "s/.*memory_limit = .*/memory_limit = -1/" /etc/${PHP}/php.ini

WORKDIR /work

CMD ["phpcs", "--standard=Drupal,DrupalPractice", "."]
