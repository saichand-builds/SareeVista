-- Create Database
CREATE DATABASE SareesDB;
GO

USE SareesDB;
GO

-- Users table
CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(100) NOT NULL,
    last_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(255) NOT NULL UNIQUE,
    phone NVARCHAR(20),
    password_hash NVARCHAR(255) NOT NULL,
    role NVARCHAR(20) NOT NULL CHECK (role IN ('customer','admin')),
    is_active BIT NOT NULL DEFAULT 1,
    address NVARCHAR(MAX),
    city NVARCHAR(100),
    state NVARCHAR(100),
    pincode NVARCHAR(10),
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    last_login DATETIME2
);

-- Categories table
CREATE TABLE Categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    image_url NVARCHAR(500),
    is_active BIT NOT NULL DEFAULT 1,
    display_order INT NOT NULL DEFAULT 0,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

-- Products table
CREATE TABLE Products (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(200) NOT NULL,
    slug NVARCHAR(200) NOT NULL UNIQUE,
    description NVARCHAR(MAX),
    category_id INT REFERENCES Categories(category_id),
    fabric NVARCHAR(100),
    color NVARCHAR(100),
    occasion NVARCHAR(100),
    work_type NVARCHAR(100),
    price DECIMAL(10,2) NOT NULL,
    discount_price DECIMAL(10,2),
    stock_quantity INT NOT NULL DEFAULT 0,
    images NVARCHAR(MAX),
    is_featured BIT NOT NULL DEFAULT 0,
    is_new BIT NOT NULL DEFAULT 0,
    is_active BIT NOT NULL DEFAULT 1,
    rating DECIMAL(3,2) DEFAULT 0,
    total_reviews INT NOT NULL DEFAULT 0,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME2
);

-- Cart table
CREATE TABLE Cart (
    cart_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL REFERENCES Users(user_id),
    product_id INT NOT NULL REFERENCES Products(product_id),
    quantity INT NOT NULL DEFAULT 1,
    added_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    UNIQUE (user_id, product_id)
);

-- Orders table
CREATE TABLE Orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    order_number NVARCHAR(50) NOT NULL UNIQUE,
    user_id INT NOT NULL REFERENCES Users(user_id),
    order_date DATETIME2 NOT NULL DEFAULT GETDATE(),
    subtotal DECIMAL(10,2) NOT NULL,
    shipping_charge DECIMAL(10,2) NOT NULL DEFAULT 0,
    discount DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_amount DECIMAL(10,2) NOT NULL,
    payment_method NVARCHAR(50) CHECK (payment_method IN ('razorpay','cod','bank_transfer')),
    payment_status NVARCHAR(30) DEFAULT 'pending',
    order_status NVARCHAR(30) DEFAULT 'pending',
    razorpay_order_id NVARCHAR(200),
    razorpay_payment_id NVARCHAR(200),
    shipping_address NVARCHAR(MAX) NOT NULL,
    shipping_city NVARCHAR(100),
    shipping_state NVARCHAR(100),
    shipping_pincode NVARCHAR(10),
    tracking_number NVARCHAR(100),
    notes NVARCHAR(MAX),
    delivered_at DATETIME2,
    cancelled_at DATETIME2,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

-- Order Items table
CREATE TABLE OrderItems (
    order_item_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL REFERENCES Orders(order_id),
    product_id INT NOT NULL REFERENCES Products(product_id),
    product_name NVARCHAR(200) NOT NULL,
    product_image NVARCHAR(500),
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

-- Reviews table
CREATE TABLE Reviews (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL REFERENCES Products(product_id),
    user_id INT NOT NULL REFERENCES Users(user_id),
    rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(MAX),
    is_visible BIT NOT NULL DEFAULT 1,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    UNIQUE (product_id, user_id)
);

-- Wishlist table
CREATE TABLE Wishlist (
    wishlist_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL REFERENCES Users(user_id),
    product_id INT NOT NULL REFERENCES Products(product_id),
    added_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    UNIQUE (user_id, product_id)
);

-- Coupons table
CREATE TABLE Coupons (
    coupon_id INT IDENTITY(1,1) PRIMARY KEY,
    code NVARCHAR(50) NOT NULL UNIQUE,
    description NVARCHAR(500),
    discount_type NVARCHAR(20) NOT NULL CHECK (discount_type IN ('percentage','fixed')),
    discount_value DECIMAL(10,2) NOT NULL,
    min_order_amount DECIMAL(10,2) DEFAULT 0,
    max_discount DECIMAL(10,2),
    valid_from DATETIME2 NOT NULL,
    valid_to DATETIME2 NOT NULL,
    usage_limit INT,
    used_count INT NOT NULL DEFAULT 0,
    is_active BIT NOT NULL DEFAULT 1,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

PRINT 'All tables created successfully!';
GO