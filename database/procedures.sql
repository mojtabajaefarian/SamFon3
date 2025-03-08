DELIMITER //

-- پروسیجر جزئیات محصول
CREATE PROCEDURE GetProductDetails(IN productId BIGINT)
BEGIN
    SELECT 
        p.*,
        c.name AS category_name,
        (SELECT COUNT(*) FROM order_items oi WHERE oi.product_id = p.id) AS total_sales,
        (SELECT AVG(quantity) FROM order_items oi WHERE oi.product_id = p.id) AS avg_quantity
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    WHERE p.id = productId;
END //

-- پروسیجر گزارش فروش
CREATE PROCEDURE GetSalesReport(IN startDate DATE, IN endDate DATE)
BEGIN
    SELECT 
        DATE(o.created_at) AS sale_date,
        COUNT(DISTINCT o.id) AS total_orders,
        SUM(o.total_price) AS total_revenue,
        AVG(o.total_price) AS avg_order_value
    FROM orders o
    WHERE 
        o.status = 'completed' AND
        o.created_at BETWEEN startDate AND endDate + INTERVAL 1 DAY
    GROUP BY DATE(o.created_at)
    ORDER BY sale_date;
END //

-- پروسیجر محصولات با موجودی کم
CREATE PROCEDURE CheckLowStockProducts()
BEGIN
    SELECT 
        p.id,
        p.title,
        p.stock_count,
        p.min_stock_alert,
        c.name AS category_name
    FROM products p
    JOIN categories c ON p.category_id = c.id
    WHERE 
        p.stock_count <= p.min_stock_alert AND
        p.status = 'active'
    ORDER BY p.stock_count ASC;
END //

DELIMITER ;