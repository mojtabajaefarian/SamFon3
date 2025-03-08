-- Database Setup با تنظیمات بهینه
CREATE DATABASE IF NOT EXISTS samfon_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE samfon_db;

-- تنظیمات اجرایی
SET @@SESSION.SQL_MODE = 'TRADITIONAL,ALLOW_INVALID_DATES';

-- جدول کاربران
CREATE TABLE users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    mobile VARCHAR(15) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'user', 'vendor') DEFAULT 'user',
    status ENUM('active', 'inactive', 'blocked') DEFAULT 'active',
    sms_token VARCHAR(10),
    last_login TIMESTAMP NULL,
    login_attempts TINYINT UNSIGNED DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_mobile_status (mobile, status),
    INDEX idx_login_attempts (login_attempts),
    UNIQUE INDEX ux_mobile (mobile)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC;

-- جدول دسته‌بندی‌ها
CREATE TABLE categories (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(120) NOT NULL,
    parent_id INT UNSIGNED NULL,
    level TINYINT UNSIGNED DEFAULT 0,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_parent_status (parent_id, status),
    INDEX idx_slug (slug)
) ENGINE=InnoDB;

-- جدول محصولات
CREATE TABLE products (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL,
    description LONGTEXT,
    price DECIMAL(12,2) UNSIGNED NOT NULL,
    special_price DECIMAL(12,2) UNSIGNED NULL,
    category_id INT UNSIGNED NOT NULL,
    stock_count INT UNSIGNED DEFAULT 0,
    min_stock_alert INT UNSIGNED DEFAULT 5,
    image_url VARCHAR(255),
    status ENUM('active', 'inactive', 'out_of_stock') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FULLTEXT INDEX fidx_search (title, description),
    INDEX idx_price_stock (price, stock_count),
    INDEX idx_category_status (category_id, status)
) ENGINE=InnoDB;

-- جدول سفارشات
CREATE TABLE orders (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    total_price DECIMAL(12,2) UNSIGNED NOT NULL,
    status ENUM('pending', 'processing','completed', 'failed', 'canceled') DEFAULT 'pending',
    payment_method ENUM('online', 'cash', 'wallet') NOT NULL,
    tracking_code VARCHAR(50) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_status (user_id, status),
    INDEX idx_created_status (created_at, status),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- جدول آیتم‌های سفارش
-- جدول آیتم‌های سفارش (ادامه)
CREATE TABLE order_items (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    quantity SMALLINT UNSIGNED NOT NULL,
    price DECIMAL(10,2) UNSIGNED NOT NULL,
    discount DECIMAL(10,2) UNSIGNED DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_order_product (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- جدول لاگ سیستم
CREATE TABLE system_logs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    log_type ENUM('security', 'performance', 'error', 'order', 'user_activity') NOT NULL,
    user_id BIGINT UNSIGNED NULL,
    ip_address VARBINARY(16) NOT NULL,
    action TEXT NOT NULL,
    severity ENUM('low', 'medium', 'high', 'critical') DEFAULT 'low',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_log_type_severity (log_type, severity),
    INDEX idx_user_activity (user_id, log_type)
) ENGINE=InnoDB;
