
CREATE DATABASE zomato;

-- Connect to zomato database before executing further queries

-- 1. USERS
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. ADDRESSES
CREATE TABLE addresses (
    address_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    address_line TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    pincode VARCHAR(10),
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7)
);

-- 3. RESTAURANTS
CREATE TABLE restaurants (
    restaurant_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    rating DECIMAL(2,1) DEFAULT 0,
    is_open BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. RESTAURANT OWNERS
CREATE TABLE restaurant_owners (
    owner_id SERIAL PRIMARY KEY,
    restaurant_id INT REFERENCES restaurants(restaurant_id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- 5. FOOD CATEGORIES
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- 6. MENU ITEMS
CREATE TABLE menu_items (
    item_id SERIAL PRIMARY KEY,
    restaurant_id INT REFERENCES restaurants(restaurant_id) ON DELETE CASCADE,
    category_id INT REFERENCES categories(category_id),
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    is_vegetarian BOOLEAN DEFAULT FALSE,
    is_available BOOLEAN DEFAULT TRUE
);

-- 7. CART
CREATE TABLE carts (
    cart_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    restaurant_id INT REFERENCES restaurants(restaurant_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 8. CART ITEMS
CREATE TABLE cart_items (
    cart_item_id SERIAL PRIMARY KEY,
    cart_id INT REFERENCES carts(cart_id) ON DELETE CASCADE,
    item_id INT REFERENCES menu_items(item_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    UNIQUE(cart_id, item_id)
);

-- 9. DELIVERY PARTNERS
CREATE TABLE delivery_partners (
    partner_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    vehicle_number VARCHAR(20),
    is_available BOOLEAN DEFAULT TRUE
);

-- 10. ORDERS
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    restaurant_id INT REFERENCES restaurants(restaurant_id),
    address_id INT REFERENCES addresses(address_id),
    partner_id INT REFERENCES delivery_partners(partner_id),
    order_status VARCHAR(30) DEFAULT 'PLACED'
        CHECK (order_status IN (
            'PLACED',
            'CONFIRMED',
            'PREPARING',
            'READY',
            'OUT_FOR_DELIVERY',
            'DELIVERED',
            'CANCELLED'
        )),
    total_amount DECIMAL(10,2) NOT NULL,
    delivery_fee DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 11. ORDER ITEMS
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    item_id INT REFERENCES menu_items(item_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    item_price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL
);

-- 12. PAYMENTS
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT UNIQUE REFERENCES orders(order_id),
    payment_method VARCHAR(30) NOT NULL,
    payment_status VARCHAR(30) DEFAULT 'PENDING'
        CHECK (payment_status IN (
            'PENDING',
            'SUCCESS',
            'FAILED',
            'REFUNDED'
        )),
    amount DECIMAL(10,2) NOT NULL,
    transaction_id VARCHAR(150) UNIQUE,
    paid_at TIMESTAMP
);

-- 13. REVIEWS
CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    restaurant_id INT REFERENCES restaurants(restaurant_id),
    order_id INT UNIQUE REFERENCES orders(order_id),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 14. COUPONS
CREATE TABLE coupons (
    coupon_id SERIAL PRIMARY KEY,
    code VARCHAR(30) UNIQUE NOT NULL,
    discount_percentage DECIMAL(5,2)
        CHECK (discount_percentage BETWEEN 0 AND 100),
    max_discount DECIMAL(10,2),
    min_order_amount DECIMAL(10,2) DEFAULT 0,
    expiry_date TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- 15. ORDER STATUS HISTORY
CREATE TABLE order_status_history (
    history_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    status VARCHAR(30) NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- INDEXES
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_restaurants_city ON restaurants(city);
CREATE INDEX idx_menu_restaurant ON menu_items(restaurant_id);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(order_status);
CREATE INDEX idx_orders_created ON orders(created_at);
CREATE INDEX idx_reviews_restaurant ON reviews(restaurant_id);
