FROM php:8.1-apache

# Install required PHP extensions
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libzip-dev \
    unzip \
    wget \
    && docker-php-ext-install \
    curl \
    pdo \
    pdo_mysql \
    xml \
    zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod rewrite headers

# Set working directory
WORKDIR /var/www/html

# Download and install RainLoop
RUN wget -qO- https://www.rainloop.net/repository/webmail/rainloop-latest.zip > rainloop.zip \
    && unzip rainloop.zip \
    && rm rainloop.zip \
    && find . -type d -exec chmod 755 {} \; \
    && find . -type f -exec chmod 644 {} \; \
    && chown -R www-data:www-data /var/www/html

# Create data directory
RUN mkdir -p /var/www/html/data \
    && chown -R www-data:www-data /var/www/html/data

# Copy custom configuration
COPY rainloop-config.php /var/www/html/data/_data_/_default_/configs/application.ini

# Set permissions
RUN chmod -R 755 /var/www/html/data

# Expose port
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Start Apache
CMD ["apache2-foreground"]
