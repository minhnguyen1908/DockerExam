FROM drupal

RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    rm -rf /var/lig/apt/list/*

WORKDIR /var/www/html/themes

RUN git clone https://git.drupal.org/project/bootstrap.git
WORKDIR /var/www/html/themes/bootstrap
RUN git checkout 8.x-3.x

WORKDIR /var/www/html/themes
RUN rm -rf .git && \
    chown -R www-data:www-data /var/www/html/themes

WORKDIR /var/www/html

USER www-data
