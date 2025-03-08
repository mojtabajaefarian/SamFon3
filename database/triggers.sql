DELIMITER //

-- تریگر بروزرسانی موجودی محصول
CREATE TRIGGER trg_update_product_stock 
AFTER INSERT ON order_items
FOR EACH ROW 
BEGIN
    DECLARE current_stock INT;
    DECLARE min_alert INT;
    
    SELECT stock_count, min_stock_alert 
    INTO current_stock, min_alert
    FROM products 
    WHERE id = NEW.product_id
    FOR UPDATE;
    
    SET current_stock = current_stock - NEW.quantity;
    
    UPDATE products 
    SET stock_count = current_stock
    WHERE -- تریگر بروزرسانی موجودی محصول (ادامه)
    id = NEW.product_id;
    
    IF current_stock <= min_alert THEN
        INSERT INTO system_logs 
        (log_type, action, severity) 
        VALUES 
        ('performance', CONCAT('Low stock alert for product ID: ', NEW.product_id), 'high');
    END IF;
END //

-- تریگر ثبت لاگ ورود کاربر
CREATE TRIGGER trg_user_login_log
AFTER UPDATE ON users
FOR EACH ROW
BEGIN
    IF NEW.last_login IS NOT NULL AND NEW.last_login != OLD.last_login THEN
        INSERT INTO system_logs 
        (log_type, user_id, action, severity)
        VALUES 
        ('user_activity', NEW.id, 'User logged in', 'low');
    END IF;
END //

-- تریگر محدودسازی تعداد تلاش‌های ورود
CREATE TRIGGER trg_login_attempts
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    IF NEW.login_attempts >= 5 THEN
        SET NEW.status = 'blocked';
        INSERT INTO system_logs 
        (log_type, user_id, action, severity)
        VALUES 
        ('security', NEW.id, 'User account blocked due to multiple login attempts', 'high');
    END IF;
END //

DELIMITER ;