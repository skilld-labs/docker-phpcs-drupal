FROM skilldlabs/docker-phpcs-drupal:latest

RUN composer global require escapestudios/symfony2-coding-standard:~2.0 \
    && ln -s /root/.composer/vendor/escapestudios/symfony2-coding-standard/Symfony2 /root/.composer/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards/Symfony2

CMD ["phpcs", "--standard=Symfony2", "."]
