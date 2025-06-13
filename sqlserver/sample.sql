-- Create the users table
CREATE TABLE users (
                       user_id INT IDENTITY(1,1) PRIMARY KEY,
                       first_name NVARCHAR(50) NOT NULL,
                       last_name NVARCHAR(50) NOT NULL,
                       email NVARCHAR(100) NOT NULL UNIQUE,
                       phone NVARCHAR(20),
                       address NVARCHAR(200)
);

-- Create the orders table
CREATE TABLE orders (
                        order_id INT IDENTITY(1,1) PRIMARY KEY,
                        user_id INT NOT NULL,
                        order_date DATETIME NOT NULL DEFAULT GETDATE(),
                        amount DECIMAL(10, 2) NOT NULL,
                        FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Create the employees table
CREATE TABLE employees (
                           employee_id INT IDENTITY(1,1) PRIMARY KEY,
                           first_name NVARCHAR(50) NOT NULL,
                           last_name NVARCHAR(50) NOT NULL,
                           email NVARCHAR(100) NOT NULL UNIQUE,
                           department NVARCHAR(50),
                           phone NVARCHAR(20)
);

-- Populate the users table with sample data
INSERT INTO users (first_name, last_name, email, phone, address)
VALUES
    ('John', 'Doe', 'john.doe@example.com', '+123456789', '123 Main St, Springfield'),
    ('Jane', 'Smith', 'jane.smith@example.com', '+987654321', '456 Elm St, Metropolis'),
    ('Alice', 'Johnson', 'alice.johnson@example.com', '+112233445', '789 Oak St, Gotham');

-- Populate the orders table with sample data
INSERT INTO orders (user_id, amount)
VALUES
    (1, 99.99),
    (2, 49.50),
    (3, 150.00);

-- Populate the employees table with sample data
INSERT INTO employees (first_name, last_name, email, department, phone)
VALUES
    ('Emma', 'Brown', 'emma.brown@company.com', 'Sales', '+445566778'),
    ('Liam', 'Davis', 'liam.davis@company.com', 'IT', '+556677889'),
    ('Olivia', 'Wilson', 'olivia.wilson@company.com', 'HR', '+667788990');