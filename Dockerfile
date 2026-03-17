FROM php:8.2-apache

# Instala extensões necessárias
RUN docker-php-ext-install pdo pdo_mysql bcmath

# Habilita o mod_rewrite do Apache
RUN a2enmod rewrite

# Define a pasta de trabalho
WORKDIR /var/www/html

# Copia os arquivos do projeto
COPY . .

# CRIA AS PASTAS E AJUSTA PERMISSÕES (Isso resolve o DocumentRoot not exist)
RUN mkdir -p storage bootstrap/cache public \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Aponta o Apache para a pasta PUBLIC do Laravel
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

EXPOSE 80
