FROM alpine:edge
MAINTAINER Harry Walter
MAINTAINER Andriy Yun <andriy.yun@gmail.com>

RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --update php7@testing php7-xml@testing php7-phar@testing \
    php7-openssl@testing php7-mbstring@testing php7-json@testing php7-ctype@testing \
    curl patch \
    && rm -fr /var/cache/apk/* \
    && ln -s /usr/bin/php7 /usr/bin/php \
    && curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/bin

RUN composer global require drupal/coder \
&& ln -s /root/.composer/vendor/squizlabs/php_codesniffer/scripts/phpcs /usr/bin/phpcs \
&& ln -s /root/.composer/vendor/squizlabs/php_codesniffer/scripts/phpcbf /usr/bin/phpcbf \
&& ln -s /root/.composer/vendor/drupal/coder/coder_sniffer/Drupal /root/.composer/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards/Drupal

VOLUME /work
WORKDIR /work

ENTRYPOINT ["phpcs", "--standard=Drupal"]
