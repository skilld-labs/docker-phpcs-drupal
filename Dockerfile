FROM alpine:edge

MAINTAINER Andriy Yun <andriy.yun@gmail.com>
MAINTAINER Andy Postnikov <apostnikov@gmail.com>

RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && apk add --no-cache \
  php7@testing \
  php7-xml@testing \
  php7-phar@testing \
  php7-openssl@testing \
  php7-mbstring@testing \
  php7-json@testing \
  php7-ctype@testing \
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
