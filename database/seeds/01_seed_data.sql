USE SareesDB;
GO

-- Admin user (Password: Demo@1234)
DECLARE @hash NVARCHAR(255) = '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TiGniMRXMG.Y2yBqJn6i8DvXa3oa';

IF NOT EXISTS (SELECT 1 FROM Users WHERE email='admin@sarees.com')
INSERT INTO Users (first_name, last_name, email, phone, password_hash, role, is_active, created_at)
VALUES ('Admin', 'User', 'admin@sarees.com', '+91 98765 43210', @hash, 'admin', 1, GETDATE());

-- Demo Customer
IF NOT EXISTS (SELECT 1 FROM Users WHERE email='customer@demo.com')
INSERT INTO Users (first_name, last_name, email, phone, password_hash, role, is_active, created_at)
VALUES ('Priya', 'Sharma', 'customer@demo.com', '+91 98765 43210', @hash, 'customer', 1, GETDATE());

-- Categories
IF NOT EXISTS (SELECT 1 FROM Categories)
BEGIN
    INSERT INTO Categories (name, description, display_order, is_active) VALUES
        ('Banarasi Sarees', 'Traditional Banarasi silk sarees with intricate zari work', 1, 1),
        ('Kanchipuram Sarees', 'Authentic Kanchipuram silk sarees from Tamil Nadu', 2, 1),
        ('Paithani Sarees', 'Beautiful Paithani sarees with peacock motifs', 3, 1),
        ('Chanderi Sarees', 'Lightweight Chanderi silk and cotton sarees', 4, 1),
        ('Cotton Sarees', 'Comfortable daily wear cotton sarees', 5, 1),
        ('Silk Sarees', 'Premium pure silk sarees for special occasions', 6, 1);
END;

-- Products
IF NOT EXISTS (SELECT 1 FROM Products)
BEGIN
    DECLARE @cat_banarasi INT = (SELECT category_id FROM Categories WHERE name = 'Banarasi Sarees');
    DECLARE @cat_kanchi INT = (SELECT category_id FROM Categories WHERE name = 'Kanchipuram Sarees');
    DECLARE @cat_paithani INT = (SELECT category_id FROM Categories WHERE name = 'Paithani Sarees');

    INSERT INTO Products (name, slug, description, category_id, fabric, color, occasion, work_type, price, discount_price, stock_quantity, images, is_featured, is_new, is_active) VALUES
        ('Red Banarasi Silk Saree', 'red-banarasi-silk-saree', 'Pure silk Banarasi saree with heavy gold zari work. Perfect for weddings.', @cat_banarasi, 'Pure Silk', 'Red', 'Wedding', 'Banarasi', 12500, 9999, 10, '["/images/sarees/banarasi-red-1.jpg"]', 1, 1, 1),
        ('Green Banarasi Georgette Saree', 'green-banarasi-georgette-saree', 'Beautiful green Banarasi georgette saree with silver zari work.', @cat_banarasi, 'Georgette', 'Green', 'Festival', 'Banarasi', 8500, 6999, 15, '["/images/sarees/banarasi-green-1.jpg"]', 1, 0, 1),
        ('Kanchipuram Pink Silk Saree', 'kanchipuram-pink-silk-saree', 'Authentic Kanchipuram silk saree with traditional temple border.', @cat_kanchi, 'Pure Silk', 'Pink', 'Wedding', 'Kanchipuram', 18000, 14999, 8, '["/images/sarees/kanchi-pink-1.jpg"]', 1, 1, 1),
        ('Kanchipuram Blue Silk Saree', 'kanchipuram-blue-silk-saree', 'Royal blue Kanchipuram silk saree with golden brocade work.', @cat_kanchi, 'Pure Silk', 'Blue', 'Party', 'Kanchipuram', 15000, 12999, 12, '["/images/sarees/kanchi-blue-1.jpg"]', 0, 0, 1),
        ('Paithani Purple Saree', 'paithani-purple-saree', 'Handwoven Paithani saree with traditional peacock motif border.', @cat_paithani, 'Silk', 'Purple', 'Festival', 'Paithani', 22000, 18999, 5, '["/images/sarees/paithani-purple-1.jpg"]', 1, 1, 1),
        ('Cotton Printed Saree', 'cotton-printed-saree', 'Comfortable cotton saree with floral prints. Ideal for daily wear.', (SELECT category_id FROM Categories WHERE name = 'Cotton Sarees'), 'Cotton', 'Multi', 'Daily Wear', 'Printed', 2500, 1999, 50, '["/images/sarees/cotton-floral-1.jpg"]', 0, 0, 1),
        ('White Kanchipuram Silk Saree', 'white-kanchipuram-silk-saree', 'Elegant white Kanchipuram silk saree with golden border.', @cat_kanchi, 'Pure Silk', 'White', 'Wedding', 'Kanchipuram', 16000, 13999, 7, '["/images/sarees/kanchi-white-1.jpg"]', 1, 0, 1),
        ('Banarasi Yellow Saree', 'banarasi-yellow-saree', 'Bright yellow Banarasi saree with zari border.', @cat_banarasi, 'Silk', 'Yellow', 'Festival', 'Banarasi', 9500, 7999, 10, '["/images/sarees/banarasi-yellow-1.jpg"]', 0, 1, 1),
        ('Paithani Green Saree', 'paithani-green-saree', 'Beautiful green Paithani saree with traditional border.', @cat_paithani, 'Silk', 'Green', 'Wedding', 'Paithani', 19500, 16999, 6, '["/images/sarees/paithani-green-1.jpg"]', 0, 0, 1);
END;

-- Coupons
IF NOT EXISTS (SELECT 1 FROM Coupons)
BEGIN
    INSERT INTO Coupons (code, description, discount_type, discount_value, min_order_amount, max_discount, valid_from, valid_to, usage_limit, is_active) VALUES
        ('WELCOME10', '10% off on first order', 'percentage', 10, 1000, 500, DATEADD(DAY, -1, GETDATE()), DATEADD(YEAR, 1, GETDATE()), 100, 1),
        ('SAREE50', 'FLAT ₹50 off on orders above ₹999', 'fixed', 50, 999, 50, DATEADD(DAY, -1, GETDATE()), DATEADD(MONTH, 3, GETDATE()), 50, 1),
        ('FREESHIP', 'Free shipping on orders above ₹2499', 'percentage', 0, 2499, 0, DATEADD(DAY, -1, GETDATE()), DATEADD(MONTH, 6, GETDATE()), 200, 1);
END;

PRINT 'Seed data inserted successfully!';
GO