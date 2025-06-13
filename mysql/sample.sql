-- Create database
CREATE DATABASE IF NOT EXISTS soveren;
USE soveren;

-- Create users table
CREATE TABLE users (
                       id INT AUTO_INCREMENT PRIMARY KEY,
                       first_name VARCHAR(50) NOT NULL,
                       last_name VARCHAR(50) NOT NULL,
                       email VARCHAR(100) NOT NULL UNIQUE,
                       phone_number VARCHAR(20),
                       date_of_birth DATE,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create addresses table
CREATE TABLE addresses (
                           id INT AUTO_INCREMENT PRIMARY KEY,
                           user_id INT NOT NULL,
                           street_address VARCHAR(255) NOT NULL,
                           city VARCHAR(100) NOT NULL,
                           state VARCHAR(50),
                           postal_code VARCHAR(20),
                           country VARCHAR(50) NOT NULL,
                           created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                           FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create transactions table
CREATE TABLE transactions (
                              id INT AUTO_INCREMENT PRIMARY KEY,
                              user_id INT NOT NULL,
                              transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                              amount DECIMAL(10, 2) NOT NULL,
                              currency VARCHAR(10) DEFAULT 'USD',
                              transaction_type ENUM('credit', 'debit') NOT NULL,
                              description TEXT,
                              FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create orders table
CREATE TABLE orders (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        user_id INT NOT NULL,
                        order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        total_amount DECIMAL(10, 2) NOT NULL,
                        status ENUM('pending', 'completed', 'canceled') DEFAULT 'pending',
                        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Insert sample data into users table
INSERT INTO users (first_name, last_name, email, phone_number, date_of_birth)
VALUES
    ('John', 'Doe', 'john.doe@example.com', '1234567890', '1985-01-15'),
    ('Jane', 'Smith', 'jane.smith@example.com', '9876543210', '1990-07-22'),
    ('Alice', 'Johnson', 'alice.johnson@example.com', NULL, '1995-03-10'),
    ('Bob', 'Brown', 'bob.brown@example.com', '5555555555', '2000-11-02');

-- Insert sample data into addresses table
INSERT INTO addresses (user_id, street_address, city, state, postal_code, country)
VALUES
    (1, '123 Main St', 'New York', 'NY', '10001', 'USA'),
    (2, '456 Elm St', 'Los Angeles', 'CA', '90001', 'USA'),
    (3, '789 Oak St', 'Chicago', 'IL', '60601', 'USA'),
    (4, '101 Maple St', 'Houston', 'TX', '77001', 'USA');

-- Insert sample data into transactions table
INSERT INTO transactions (user_id, amount, currency, transaction_type, description)
VALUES
    (1, 100.00, 'USD', 'credit', 'Initial deposit'),
    (1, 50.00, 'USD', 'debit', 'Purchase at Store A'),
    (2, 200.00, 'USD', 'credit', 'Paycheck'),
    (3, 75.50, 'USD', 'debit', 'Subscription payment'),
    (4, 150.00, 'USD', 'credit', 'Refund');

-- Insert sample data into orders table
INSERT INTO orders (user_id, total_amount, status)
VALUES
    (1, 49.99, 'completed'),
    (2, 79.99, 'pending'),
    (3, 19.99, 'canceled'),
    (4, 120.00, 'completed');