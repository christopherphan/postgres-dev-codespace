-- Sample initialization script
-- This runs automatically when the database is first created

-- Create a sample table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create a sample products table
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert some sample data
INSERT INTO users (username, email) VALUES 
    ('demo_user', 'demo@example.com'),
    ('test_user', 'test@example.com'),
    ('admin', 'admin@example.com')
ON CONFLICT (username) DO NOTHING;

INSERT INTO products (name, description, price) VALUES 
    ('Sample Product 1', 'This is a demo product for testing', 29.99),
    ('Sample Product 2', 'Another demo product', 49.99),
    ('Premium Item', 'A premium demo item', 99.99)
ON CONFLICT DO NOTHING;

-- Create an index for better performance
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_products_name ON products(name);