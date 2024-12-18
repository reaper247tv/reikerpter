FROM pterodactyl/panel:latest

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . .

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Permissions
RUN chown -R www-data:www-data /var/www/html

# Expose the default web server port
EXPOSE 80

# Start command
CMD ["node", "runner.js"]