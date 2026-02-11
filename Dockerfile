FROM php:8.1-apache

# Install required packages and PHP extensions
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    libicu-dev \
    libonig-dev \
    libxml2-dev \
    curl \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    gd \
    mysqli \
    pdo \
    pdo_mysql \
    zip \
    intl \
    mbstring \
    xml \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod rewrite headers

# Download and install Afterlogic WebMail Lite
WORKDIR /var/www/html
RUN curl -L https://afterlogic.org/download/webmail_php.zip -o webmail.zip \
    && unzip webmail.zip \
    && rm webmail.zip \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Create data directory with proper permissions
RUN mkdir -p /var/www/html/data \
    && chown -R www-data:www-data /var/www/html/data \
    && chmod -R 777 /var/www/html/data

# Expose port
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
