# استفاده از image رسمی PHP با Apache
FROM php:8.1-apache

# فعالسازی ماژول‌های ضروری Apache
RUN a2enmod rewrite headers

# نصب پیش‌نیازهای سیستم
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    unzip \
    && docker-php-ext-install pdo_mysql mysqli zip gd

# کپی فایل‌های پروژه
COPY . /var/www/html/

# تنظیم مجوزها
RUN chown -R www-data:www-data /var/www/html/storage

# نصب Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# نصب وابستگی‌ها
RUN composer install --no-dev --optimize-autoloader

# پیکربندی محیط
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf