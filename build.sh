#!/bin/sh

set -e -x

docker build --pull \
  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
  --build-arg VCS_REF=`git rev-parse --short HEAD` \
  -t skilldlabs/docker-phpcs-drupal .

cd ci

docker build -t skilldlabs/docker-phpcs-drupal:ci .
