# Base image
FROM php:8.1-fpm-alpine

# Set working directory
WORKDIR /var/www/html

# Install dependencies
RUN apk add --no-cache \
    nginx \
    supervisor \
    openssl \
    libpng \
    libpng-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    libpq-dev \
    zlib-dev \
    libzip-dev \
    unzip \
    git \
    vim

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql pdo_pgsql gd zip opcache 

# Copy application files
# COPY . /var/www/html

# Configure Nginx
COPY nginx/nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /run/nginx

# Configure PHP.ini
COPY php/php.ini /usr/local/etc/php/php.ini

# Configure Supervisor
COPY supervisord/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose port 80
EXPOSE 80

# Start services
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
