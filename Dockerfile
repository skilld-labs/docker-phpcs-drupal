FROM alpine:3.6

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
  php7 \
  php7-apcu \
  php7-ctype \
  php7-json \
  php7-mbstring \
  php7-opcache \
  php7-openssl \
  php7-phar \
  php7-simplexml \
  php7-tokenizer \
  php7-xmlwriter \
  php7-zlib \
  && curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/bin \
  && composer global require drupal/coder --update-no-dev --no-suggest --prefer-dist ^8.3 \
  && ln -s /root/.composer/vendor/bin/phpcs /usr/bin/phpcs \
  && ln -s /root/.composer/vendor/bin/phpcbf /usr/bin/phpcbf \
  && ln -s /root/.composer/vendor/drupal/coder/coder_sniffer/Drupal /root/.composer/vendor/squizlabs/php_codesniffer/src/Standards/Drupal \
  && ln -s /root/.composer/vendor/drupal/coder/coder_sniffer/DrupalPractice /root/.composer/vendor/squizlabs/php_codesniffer/src/Standards/DrupalPractice \
  && git clone --branch master https://git.drupal.org/sandbox/coltrane/1921926.git /root/drupalsecure_code_sniffs \
  && rm -rf /root/drupalsecure_code_sniffs/.git \
  && cd /root/drupalsecure_code_sniffs && curl https://www.drupal.org/files/issues/parenthesis_closer_notice-2320623-2.patch | git apply && cd \
  && apk del --no-cache git \
  && rm -rf /root/.composer/cache/* \
  && ln -s /root/drupalsecure_code_sniffs/DrupalSecure /root/.composer/vendor/squizlabs/php_codesniffer/src/Standards/DrupalSecure \
  && sed -i "s/.*memory_limit = .*/memory_limit = -1/" /etc/php7/php.ini

VOLUME /work
WORKDIR /work

CMD ["phpcs", "--standard=Drupal,DrupalPractice", "."]
