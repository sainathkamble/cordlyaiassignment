-- Create tables with intentionally messy schema

-- Users table with mixed naming conventions and some denormalization
CREATE TABLE Users (
    UserID SERIAL PRIMARY KEY,
    user_name VARCHAR(50),
    Email VARCHAR(100),
    phone_num VARCHAR(20),
    address_json JSONB,  -- Storing address as JSON instead of normalized
    user_metadata TEXT,  -- Unstructured metadata
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    LastLoginTS TIMESTAMP,  -- Inconsistent naming
    isActive BOOLEAN DEFAULT true
);

-- Products with inconsistent data types and redundant fields
CREATE TABLE products_inventory (
    prod_id VARCHAR(36) PRIMARY KEY,  -- Using UUID as string
    ProductName TEXT,
    price NUMERIC(10,2),
    price_string VARCHAR(20),  -- Redundant price field
    description TEXT,
    stock INTEGER,
    stock_status VARCHAR(20),  -- Redundant status
    category_id INT,
    tags TEXT[],  -- Array of tags
    metadata JSONB,
    created TIMESTAMP,
    modified_date DATE  -- Different date format
);

-- Orders with denormalization and mixed conventions
CREATE TABLE Orders_Main (
    OrderID BIGSERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES Users(UserID),
    order_date TIMESTAMP,
    Status VARCHAR(20),
    total_amount DECIMAL(12,2),
    shipping_address TEXT,  -- Denormalized address
    billing_address TEXT,   -- Denormalized address
    items_json JSONB,      -- Storing order items as JSON
    payment_info VARCHAR(255),
    notes TEXT[]
);

-- Inconsistent junction table
CREATE TABLE Product_Categories (
    CategoryID INTEGER PRIMARY KEY,
    cat_name VARCHAR(100),
    parent_cat_id INTEGER,
    meta JSONB,
    active_status CHAR(1),  -- Using Y/N instead of boolean
    created_by INTEGER,
    created_ts TIMESTAMP
);

-- Table with redundant columns and mixed data types
CREATE TABLE customer_feedback (
    feedback_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    UserID INTEGER REFERENCES Users(UserID),
    prod_id VARCHAR(36) REFERENCES products_inventory(prod_id),
    rating SMALLINT,
    rating_text VARCHAR(20),  -- Redundant rating as text
    feedback_text TEXT,
    sentiment_score DECIMAL(3,2),
    feedback_date TIMESTAMP,
    is_verified BOOLEAN,
    verified_date DATE,  -- Different date format
    response_json JSONB
);

-- Comments with minimal structure
CREATE TABLE Comments (
    id SERIAL PRIMARY KEY,
    parent_id INTEGER,
    entity_type VARCHAR(50),  -- Generic entity reference
    entity_id VARCHAR(100),   -- Generic entity ID
    comment_data JSONB,       -- All comment data in JSON
    created_at TIMESTAMP
);

-- Add some indexes with inconsistent naming
CREATE INDEX idx_users_email ON Users(Email);
CREATE INDEX products_inventory_name_idx ON products_inventory(ProductName);
CREATE INDEX OrdersUserID ON Orders_Main(user_id);
CREATE INDEX feedback_user ON customer_feedback(UserID);

-- Add some sample data
INSERT INTO Users (user_name, Email, phone_num, address_json) 
VALUES 
('john_doe', 'john@example.com', '123-456-7890', 
 '{"street": "123 Main St", "city": "Springfield", "country": "USA"}'::jsonb);

INSERT INTO products_inventory (prod_id, ProductName, price, price_string, stock, stock_status) 
VALUES 
('prod-001', 'Laptop', 999.99, '$999.99', 50, 'IN_STOCK');

INSERT INTO Product_Categories (CategoryID, cat_name, active_status) 
VALUES 
(1, 'Electronics', 'Y'); 