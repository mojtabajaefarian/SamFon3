-- ایندکس‌های اضافی برای بهبود عملکرد
CREATE INDEX idx_product_search ON products (title, description(50)) USING BTREE;
CREATE INDEX idx_user_performance ON users (last_login, login_attempts) USING BTREE;
CREATE INDEX idx_order_user_date ON orders (user_id, created_at);
CREATE INDEX idx_orderitem_product ON order_items (product_id);