# Use an official PHP image as the base
FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    curl \
    libmcrypt-dev \
    mariadb-client \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    zip \
    libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl gd

# Set working directory
WORKDIR /var/www/html

# Clone Pterodactyl Panel source code
RUN git clone https://github.com/pterodactyl/panel.git . \
    && git checkout $(git describe --tags $(git rev-list --tags --max-count=1))

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache

# Expose web server port
EXPOSE 80

# Run the Apache server
CMD ["apache2-foreground"]
