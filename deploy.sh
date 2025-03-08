#!/bin/bash

# تنظیمات سرور
SERVER_IP="your-server-ip"
SERVER_USER="username"
DEPLOY_DIR="/var/www/samfon"
BRANCH="main"

echo "🚀 Starting deployment..."

# 1. انتقال فایل‌ها با rsync
rsync -avz --delete \
    --exclude='.env' \
    --exclude='.git' \
    --exclude='storage' \
    --exclude='node_modules' \
    -e ssh ./ $SERVER_USER@$SERVER_IP:$DEPLOY_DIR

# 2. اجرای دستورات روی سرور
ssh $SERVER_USER@$SERVER_IP << EOF
    cd $DEPLOY_DIR

    # به‌روزرسانی وابستگی‌ها
    composer install --no-dev --optimize-autoloader

    # تنظیم مجوزها
    chmod -R 755 storage
    chown -R www-data:www-data storage

    # اجرای migration
    php artisan migrate --force

    # ریستارت سرویس‌ها
    sudo systemctl restart apache2
    sudo systemctl restart redis-server

    # کشینگ
    php artisan optimize:clear
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache

    echo "✅ Deployment successful!"
EOF