FROM php:8.2-apache

# 1. Instala dependências do sistema e extensões PHP
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo pdo_mysql bcmath zip

# 2. Instala o Composer (O cara que cria a pasta vendor)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 3. Habilita o mod_rewrite do Apache
RUN a2enmod rewrite

WORKDIR /var/www/html

# 4. Copia os arquivos do projeto
COPY . .

# 5. Roda o comando para criar a pasta VENDOR
# O --no-dev deixa o app mais leve para o Render
RUN composer install --no-dev --optimize-autoloader --no-scripts

# 6. Cria as pastas necessárias e ajusta permissões
RUN mkdir -p storage bootstrap/cache \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 775 storage bootstrap/cache

# 7. Aponta o Apache para a pasta public
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

EXPOSE 80
