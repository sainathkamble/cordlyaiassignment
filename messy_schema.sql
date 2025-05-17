-- Intentionally messy tables with bad naming and structure

-- A table with cryptic naming and mixed concerns
CREATE TABLE tbl1 (
    col1 INTEGER PRIMARY KEY,  -- Actually customer_id
    col2 DECIMAL(10,2),       -- Actually purchase_amount
    dt VARCHAR(10),           -- Date in string format YYYY-MM-DD
    typ CHAR(1),             -- Payment type (C/D/X)
    notes TEXT,              -- Random notes
    x JSON                   -- Misc data
);

-- Products table with redundant and unclear columns
CREATE TABLE stuff (
    thing_id VARCHAR(20) PRIMARY KEY,
    nm VARCHAR(100),          -- Product name
    c DECIMAL(10,2),         -- Cost
    p DECIMAL(10,2),         -- Price
    q INTEGER,               -- Quantity
    t VARCHAR(50),           -- Type
    seas TEXT[],             -- Seasons array
    meta JSONB               -- Metadata
);

-- Sales with denormalized and redundant data
CREATE TABLE DATA_2023_SALES (
    id SERIAL PRIMARY KEY,
    cust INTEGER REFERENCES tbl1(col1),
    item VARCHAR(20) REFERENCES stuff(thing_id),
    amt DECIMAL(10,2),
    amt_txt VARCHAR(20),     -- Same amount as text with currency
    dt DATE,
    month_num INTEGER,
    season VARCHAR(20),
    temp_celsius DECIMAL(5,2),
    weather_desc TEXT,
    success_flag CHAR(1)     -- Y/N flag
);

-- Weather data mixed with location
CREATE TABLE weather_and_store_data (
    loc_id SERIAL PRIMARY KEY,
    store_name TEXT,
    city TEXT,
    temp INTEGER,            -- Average temperature
    weather TEXT,
    season VARCHAR(10),
    store_rating DECIMAL(3,2),
    manager_notes JSONB
);

-- Insert sample data
INSERT INTO tbl1 (col1, col2, dt, typ, notes, x) VALUES
(1, 150.50, '2023-01-15', 'C', 'winter purchase', '{"age": 25}'),
(2, 200.75, '2023-02-20', 'D', 'regular customer', '{"age": 35}'),
(3, 75.25, '2023-06-10', 'C', 'summer sale', '{"age": 28}'),
(4, 300.00, '2023-12-05', 'X', 'holiday shopping', '{"age": 45}');

INSERT INTO stuff (thing_id, nm, c, p, q, t, seas, meta) VALUES
('PROD1', 'Winter Jacket', 50.00, 150.00, 100, 'Clothing', ARRAY['Winter'], '{"color": "blue"}'),
('PROD2', 'Sunscreen', 5.00, 15.00, 200, 'Health', ARRAY['Summer'], '{"spf": 50}'),
('PROD3', 'Hot Chocolate', 2.00, 8.00, 150, 'Beverage', ARRAY['Winter', 'Fall'], '{"type": "dark"}'),
('PROD4', 'Beach Umbrella', 20.00, 45.00, 75, 'Outdoor', ARRAY['Summer'], '{"size": "large"}');

INSERT INTO DATA_2023_SALES (cust, item, amt, amt_txt, dt, month_num, season, temp_celsius, weather_desc, success_flag) VALUES
(1, 'PROD1', 150.00, '$150.00', '2023-01-15', 1, 'Winter', 2.5, 'Snowy', 'Y'),
(2, 'PROD3', 24.00, '$24.00', '2023-02-20', 2, 'Winter', 5.0, 'Cold', 'Y'),
(3, 'PROD2', 15.00, '$15.00', '2023-06-10', 6, 'Summer', 28.5, 'Sunny', 'Y'),
(4, 'PROD1', 150.00, '$150.00', '2023-12-05', 12, 'Winter', 0.0, 'Snowy', 'Y'),
(1, 'PROD3', 8.00, '$8.00', '2023-12-10', 12, 'Winter', -1.0, 'Snowy', 'Y'),
(2, 'PROD2', 15.00, '$15.00', '2023-07-15', 7, 'Summer', 30.0, 'Sunny', 'Y');

INSERT INTO weather_and_store_data (store_name, city, temp, weather, season, store_rating, manager_notes) VALUES
('Store A', 'Chicago', 2, 'Snowy', 'Winter', 4.5, '{"staff": 10}'),
('Store B', 'Miami', 25, 'Sunny', 'Summer', 4.2, '{"staff": 8}'),
('Store C', 'Denver', 5, 'Cold', 'Winter', 4.8, '{"staff": 12}'); 