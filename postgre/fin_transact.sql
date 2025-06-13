CREATE DATABASE "fin_transact";

-- Run these SQL commands after connecting to the "fin_transact" database

-- Create 'accounts' table
CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    account_number VARCHAR(20) NOT NULL,
    account_type VARCHAR(50) NOT NULL,
    balance DECIMAL(14, 2) NOT NULL,
    currency VARCHAR(3) NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

-- Create 'customers' table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
);

-- Create 'transactions' table
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    account_id INTEGER,
    amount DECIMAL(14, 2) NOT NULL,
    transaction_type VARCHAR(50) NOT NULL, -- Such as 'deposit', 'withdrawal', 'payment'
    transaction_date TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
    status VARCHAR(30) NOT NULL -- Such as 'pending', 'completed', 'cancelled'
);

-- Create 'transaction_details' table
CREATE TABLE transaction_details (
    detail_id SERIAL PRIMARY KEY,
    transaction_id INTEGER,
    detail_type VARCHAR(100), -- Such as 'fee', 'interest', 'principal', 'adjustment'
    amount DECIMAL(14, 2) NOT NULL,
    description TEXT
);

-- Optional: Create 'cards' table to represent debit/credit cards linked to accounts
CREATE TABLE cards (
    card_id SERIAL PRIMARY KEY,
    account_id INTEGER,
    card_number VARCHAR(16) UNIQUE NOT NULL,
    card_type VARCHAR(30), -- Such as 'debit', 'credit'
    expiration_date DATE NOT NULL,
    cvv VARCHAR(3) NOT NULL,
    status VARCHAR(30) NOT NULL -- Such as 'active', 'blocked', 'expired'
);


-- Fill in accounts sample data (no PII - just some data)
DO $$
DECLARE
    i int := 0;
BEGIN
    WHILE i < 1000 LOOP
        INSERT INTO accounts (account_number, account_type, balance, currency) VALUES (
            LPAD(i::text, 20, '0'), -- Pads the account number with zeros
            CASE WHEN i % 2 = 0 THEN 'savings' ELSE 'checking' END,
            ROUND((random() * 100000)::numeric, 2), -- Generates a random balance
            'USD'
        );
        i := i + 1;
    END LOOP;
END $$;

-- Fill in customers
DO $$
DECLARE
    i int := 0;
    first_names text[] := ARRAY['James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer', 'Michael', 'Linda', 'William', 'Elizabeth'];
    last_names text[] := ARRAY['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez'];
    random_first_name text;
    random_last_name text;
    random_email text;
BEGIN
    FOR i IN 1..1000 LOOP
        random_first_name := first_names[1 + (RANDOM() * 9)::int];
        random_last_name := last_names[1 + (RANDOM() * 9)::int];
        random_email := LOWER(random_first_name || '.' || random_last_name || i || '@example.com');

        INSERT INTO customers (first_name, last_name, email, phone) VALUES (
            random_first_name,
            random_last_name,
            random_email,
            LPAD(((random() * 9999999999)::bigint)::text, 10, '0') -- Random 10 digit number
        );
    END LOOP;
END $$;

-- Fill in cards data
DO $$
DECLARE
    i int := 0;
    account_id_for_card int;
    card_types text[] := ARRAY['debit', 'credit'];
    card_status text[] := ARRAY['active', 'blocked', 'expired'];
    expiration_years int[] := ARRAY[1, 2, 3, 4, 5]; -- Cards expire within 1 to 5 years

BEGIN
    FOR i IN 1..1000 LOOP
        -- Randomly select an account ID from the 'accounts' table
        SELECT account_id INTO account_id_for_card
        FROM accounts
        ORDER BY RANDOM()
        LIMIT 1;

        INSERT INTO cards (account_id, card_number, card_type, expiration_date, cvv, status) VALUES (
            account_id_for_card,
            '4105107452325573', -- Your specified card number
            card_types[1 + (RANDOM() * (array_length(card_types, 1) - 1))::int],
            (CURRENT_DATE + (MAKE_INTERVAL(years => expiration_years[1 + (RANDOM() * (array_length(expiration_years, 1) - 1))::int]))),
            LPAD((RANDOM() * 999)::text, 3, '0'), -- Random CVV
            card_status[1 + (RANDOM() * (array_length(card_status, 1) - 1))::int]
        );
    END LOOP;
END $$;


-- Transaction details

DO $$
DECLARE
    i int := 0;
    transaction_id_for_detail int;
    detail_types text[] := ARRAY['fee', 'interest', 'principal', 'adjustment', 'rebate'];
    detail_description text[] := ARRAY['Monthly account fee', 'Interest for balance', 'Principal payment', 'Balance adjustment', 'Product rebate'];

BEGIN
    FOR i IN 1..1000 LOOP
        -- Randomly select a transaction ID from the 'transactions' table
        SELECT transaction_id INTO transaction_id_for_detail
        FROM transactions
        ORDER BY RANDOM()
        LIMIT 1;

        INSERT INTO transaction_details (transaction_id, detail_type, amount, description) VALUES (
            transaction_id_for_detail,
            detail_types[1 + (RANDOM() * (array_length(detail_types, 1) - 1))::int],
            ROUND((RANDOM() * 1000)::numeric, 2), -- Random amount between 0-1000
            detail_description[1 + (RANDOM() * (array_length(detail_description, 1) - 1))::int]
        );
    END LOOP;
END $$;


CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    position VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(15),
    branch_id INTEGER REFERENCES branches(branch_id),
    hire_date DATE
);

-- Sample Insert for Employees Table
INSERT INTO employees (first_name, last_name, position, email, phone_number, branch_id, hire_date) VALUES
('John', 'Doe', 'Branch Manager', 'johndoe@example.com', '555-1234', 1, '2018-06-15'),
('Jane', 'Smith', 'Teller', 'janesmith@example.com', '555-5678', 1, '2019-07-23');


CREATE TABLE branches (
    branch_id SERIAL PRIMARY KEY,
    branch_name VARCHAR(100),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    zip_code VARCHAR(10),
    phone_number VARCHAR(15)
);

-- Sample Insert for Branches Table
INSERT INTO branches (branch_name, address, city, state, zip_code, phone_number) VALUES
('Main Branch', '123 Main St', 'Metropolis', 'NY', '10101', '555-0001'),
('West Branch', '456 Elm St', 'Metropolis', 'NY', '10102', '555-0022');
