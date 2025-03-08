-- ویوی محصولات پرفروش
CREATE VIEW vw_top_selling_products AS
SELECT 
    p.id,
    p.title,
    p.category_id,
    c.name AS category_name,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * oi.price) AS total_revenue
FROM products p
JOIN order_items oi ON p.id = oi.product_id
JOIN orders o ON oi.order_id = o.id
JOIN categories c ON p.category_id = c.id
WHERE o.status = 'completed'
GROUP BY p.id, p.title, p.category_id, c.name
ORDER BY total_quantity_sold DESC
LIMIT 100;

-- ویوی گزارش فروش روزانه
CREATE VIEW vw_daily_sales_report AS
SELECT 
    DATE(created_at) AS sale_date,
    COUNT(DISTINCT id) AS total_orders,
    SUM(total_price) AS total_revenue,
    AVG(total_price) AS avg_order_value
FROM orders
WHERE status = 'completed'
GROUP BY DATE(created_at)
ORDER BY sale_date DESC;

-- ویوی وضعیت موجودی محصولات
CREATE VIEW vw_product_inventory_status AS
SELECT 
    id,
    title,
    stock_count,
    min_stock_alert,
    CASE 
        WHEN stock_count <= min_stock_alert THEN 'Low Stock'
        WHEN stock_count = 0 THEN 'Out of Stock'
        ELSE 'In Stock'
    END AS inventory_status
FROM products
ORDER BY inventory_status, stock_count;