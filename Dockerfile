FROM drupal:latest

RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    composer require 'drupal/jquery_ui:^1.7' && \
    composer require 'drupal/jquery_ui_draggable:^2.1' && \
    composer require 'drupal/jquery_ui_resizable:^2.1' && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html/themes

RUN git clone https://git.drupal.org/project/bootstrap.git
WORKDIR /var/www/html/themes/bootstrap
RUN git checkout 8.x-3.x

WORKDIR /var/www/html/themes
RUN rm -rf .git && \
    chown -R www-data:www-data /var/www/html/themes

WORKDIR /var/www/html

USER www-data
