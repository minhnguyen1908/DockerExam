
FROM drupal:8.6

RUN apt-get update && \
    apt-get install -y --no-install-recommands git && \
    rm -rf /var/lig/apt/list/*

WORKDIR /var/www/html/themes


