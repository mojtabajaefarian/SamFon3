-- ایجاد کاربر برای اپلیکیشن
CREATE USER 'samfon_app'@'localhost' 
IDENTIFIED BY 'Complex-P@ssw0rd-2024!';

-- تنظیم دسترسی‌ها
GRANT SELECT, INSERT, UPDATE, DELETE ON samfon_db.* TO 'samfon_app'@'localhost';
FLUSH PRIVILEGES;

-- تنظیم انقضای رمز عبور
ALTER USER 'samfon_app'@'localhost' 
PASSWORD EXPIRE INTERVAL 90 DAY;

-- ایجاد نقش‌های دسترسی
CREATE ROLE 'app_readonly', 'app_writer', 'app_admin';

-- تعریف دسترسی‌ها برای نقش خواندن
GRANT SELECT ON samfon_db.* TO 'app_readonly';

-- تعریف دسترسی‌ها برای نقش نوشتن
GRANT SELECT, INSERT, UPDATE ON samfon_db.* TO 'app_writer';

-- تعریف دسترسی‌ها برای نقش مدیریت
GRANT ALL PRIVILEGES ON samfon_db.* TO 'app_admin' WITH GRANT OPTION;

-- بهینه‌سازی نهایی
OPTIMIZE TABLE users, categories, products, orders, order_items, system_logs;