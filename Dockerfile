FROM php:8.2-apache

# Instala extensões necessárias
RUN docker-php-ext-install pdo pdo_mysql bcmath

# Habilita o mod_rewrite
RUN a2enmod rewrite

WORKDIR /var/www/html

# Copia TODOS os arquivos do projeto
COPY . .

# AJUSTE CRÍTICO: Garante que as pastas existam e dá permissão total
RUN mkdir -p storage bootstrap/cache public \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Configura o Apache para a pasta public
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Comando para listar os arquivos no log (ajuda a gente a debugar se o index.php sumiu)
RUN ls -la /var/www/html/public

EXPOSE 80
