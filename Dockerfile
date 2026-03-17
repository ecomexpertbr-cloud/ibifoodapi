FROM php:8.2-apache

# Instala as extensões necessárias que a Initappz pede
RUN docker-php-ext-install pdo pdo_mysql bcmath

# Copia os arquivos da sua API para o servidor
COPY . /var/www/html

# Cria as pastas caso não existam e depois ajusta as permissões
RUN chown -R www-data:www-data /var/www/html
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Habilita o Apache Rewrite para o Laravel
RUN a2enmod rewrite

# Ajusta a pasta raiz para a /public (como pede a documentação)
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

EXPOSE 80
