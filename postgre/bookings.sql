-- NEW database
CREATE DATABASE hotel_bookings;

-- Create 'guests' table
CREATE TABLE guests (
                        guest_id SERIAL PRIMARY KEY,
                        first_name VARCHAR(100) NOT NULL,
                        last_name VARCHAR(100) NOT NULL,
                        email VARCHAR(100) UNIQUE NOT NULL,
                        phone_number VARCHAR(15),
                        registration_date DATE NOT NULL
);

-- Create 'rooms' table
CREATE TABLE rooms (
                       room_id SERIAL PRIMARY KEY,
                       room_number VARCHAR(10) NOT NULL,
                       room_type VARCHAR(50) NOT NULL,
                       price_per_night DECIMAL(10, 2) NOT NULL,
                       status VARCHAR(20) NOT NULL  -- e.g., 'available', 'booked', 'maintenance'
);

-- Create 'bookings' table
CREATE TABLE bookings (
                          booking_id SERIAL PRIMARY KEY,
                          guest_id INTEGER,
                          room_id INTEGER,
                          check_in_date DATE NOT NULL,
                          check_out_date DATE NOT NULL,
                          number_of_guests INTEGER NOT NULL,
                          booking_date DATE NOT NULL,
                          status VARCHAR(20) NOT NULL  -- e.g., 'confirmed', 'cancelled', 'completed'
);

-- Create 'payments' table
CREATE TABLE payments (
                          payment_id SERIAL PRIMARY KEY,
                          booking_id INTEGER,
                          amount_paid DECIMAL(10, 2) NOT NULL,
                          payment_date DATE NOT NULL,
                          payment_method VARCHAR(50) NOT NULL  -- e.g., 'credit card', 'cash', 'online'
);

-- Create 'reviews' table
CREATE TABLE reviews (
                         review_id SERIAL PRIMARY KEY,
                         booking_id INTEGER,
                         rating INTEGER CHECK (rating >= 1 AND rating <= 5),
                         comment TEXT,
                         review_date DATE NOT NULL
);


-- Populating the 'rooms' table with a constant price per night
INSERT INTO rooms (room_number, room_type, price_per_night, status)
SELECT
    generate_series,  -- Room number based on series
    (ARRAY['Standard', 'Deluxe', 'Suite'])[floor(random()*3+1)],
    99.99,  -- Constant price for all entries
    (ARRAY['available', 'booked', 'maintenance'])[floor(random()*3+1)]
FROM generate_series(1, 1000);

-- Populating the 'guests' table
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
                INSERT INTO guests (first_name, last_name, email, phone_number, registration_date) VALUES (
                    random_first_name,
                    random_last_name,
                    random_email,
                    LPAD(((random() * 9999999999)::bigint)::text, 10, '0'), -- Random 10 digit number
                    now() - (random() * 1000)::int * INTERVAL '1 day'
                );
            END LOOP;
    END $$;



-- Populating the 'bookings' table
INSERT INTO bookings (guest_id, room_id, check_in_date, check_out_date, number_of_guests, booking_date, status)
SELECT
    floor(random() * 1000 + 1)::int,
    floor(random() * 1000 + 1)::int,
    now() - (random() * 100)::int * INTERVAL '1 day',
    now() + (random() * 10)::int * INTERVAL '1 day',
    floor(random() * 4 + 1)::int,
    now() - (random() * 100)::int * INTERVAL '1 day',
    (ARRAY['confirmed', 'cancelled', 'completed'])[floor(random()*3+1)]
FROM generate_series(1, 1000);



-- Populating the 'payments' table with a constant amount paid
INSERT INTO payments (booking_id, amount_paid, payment_date, payment_method)
SELECT
    floor(random() * 1000 + 1)::int,
    150.00,  -- Constant amount for all payments
    now() - (random() * 100)::int * INTERVAL '1 day',
    (ARRAY['credit card', 'cash', 'online'])[floor(random()*3+1)]
FROM generate_series(1, 1000);

