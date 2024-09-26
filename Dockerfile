FROM alpine:3.15

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.schema-version="1.0" \
  org.label-schema.name="docker-phpcs-drupal" \
  org.label-schema.description="PHP codesniffer for Drupal - phpcs & phpcbf" \
  org.label-schema.vcs-url="https://github.com/skilld-labs/docker-phpcs-drupal" \
  maintainer="Andriy Yun <andriy.yun@gmail.com>, Andy Postnikov <apostnikov@gmail.com>"

RUN set -e \
  && apk add --no-cache \
  curl \
  git \
  patch \
  php8 \
  php8-pecl-apcu \
  php8-ctype \
  php8-mbstring \
  php8-opcache \
  php8-openssl \
  php8-phar \
  php8-simplexml \
  php8-tokenizer \
  php8-xmlwriter;

RUN ln -s $(which php8) /usr/local/bin/php;

RUN curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/bin \
  # Require Drupal coder module to have phpcs. \
  # https://www.drupal.org/project/coder
  && composer global require drupal/coder --update-no-dev --prefer-dist ^8.3 \
  # Copy phpcs and phpcbf files into the binaries directory.
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
  && sed -i "s/.*memory_limit = .*/memory_limit = -1/" /etc/php8/php.ini

VOLUME /work
WORKDIR /work

CMD ["phpcs", "--standard=Drupal,DrupalPractice", "."]
