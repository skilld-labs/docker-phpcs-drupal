FROM alpine:edge

MAINTAINER Andriy Yun <andriy.yun@gmail.com>
MAINTAINER Andy Postnikov <apostnikov@gmail.com>

RUN apk add --no-cache \
  php7 \
  php7-xml \
  php7-phar \
  php7-openssl \
  php7-mbstring \
  php7-json \
  php7-ctype \
  curl \
  patch \
  && ln -s /usr/bin/php7 /usr/bin/php \
  && curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/bin \
  && composer global require drupal/coder \
  && ln -s /root/.composer/vendor/squizlabs/php_codesniffer/scripts/phpcs /usr/bin/phpcs \
  && ln -s /root/.composer/vendor/squizlabs/php_codesniffer/scripts/phpcbf /usr/bin/phpcbf \
  && ln -s /root/.composer/vendor/drupal/coder/coder_sniffer/Drupal /root/.composer/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards/Drupal \
  && ln -s /root/.composer/vendor/drupal/coder/coder_sniffer/DrupalPractice /root/.composer/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards/DrupalPractice

VOLUME /work
WORKDIR /work

CMD ["phpcs", "--standard=Drupal", "."]
