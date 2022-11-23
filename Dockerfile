FROM php:7.4-fpm

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Install system dependencies
RUN apt-get -y update && apt-get -y install --no-install-recommends \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    libpq-dev \
    libsqlite3-dev \
    libcurl4-openssl-dev \
    pkg-config \
    libssl-dev

#RUN pecl install mongodb && echo "extension=mongodb.so" >> $PHP_INI_DIR/php.ini
RUN pecl install mongodb &&  echo "extension=mongodb.so" > $PHP_INI_DIR/conf.d/mongo.ini

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install zip pdo_mysql pdo_pgsql pdo_sqlite mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:2.4.4 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www
