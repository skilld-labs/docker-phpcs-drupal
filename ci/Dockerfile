FROM skilldlabs/docker-phpcs-drupal:latest

MAINTAINER Andriy Yun <andriy.yun@gmail.com>
MAINTAINER Andy Postnikov <apostnikov@gmail.com>

RUN apk add --no-cache git \
  && curl -o /usr/bin/gitlab-ci-multi-runner https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/master/binaries/gitlab-ci-multi-runner-linux-amd64 \
  && chmod +x /usr/bin/gitlab-ci-multi-runner \
  && ln -s /usr/bin/gitlab-ci-multi-runner /usr/bin/gitlab-runner \
  && ln -s /usr/bin/gitlab-ci-multi-runner /usr/bin/gitlab-runner-helper
