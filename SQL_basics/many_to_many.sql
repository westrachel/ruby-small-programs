CREATE DATABASE billing;
\c billing

CREATE TABLE customers (
    id serial PRIMARY KEY,
    name text NOT NULL,
    payment_token char(8) NOT NULL UNIQUE CHECK (payment_token ~ '^[A-Z]{8}$')
);

CREATE TABLE services (
    id serial PRIMARY KEY,
    description text NOT NULL,
    price numeric(10,2) NOT NULL CHECK (price >= 0.00)
);

INSERT INTO customers (name, payment_token)
    VALUES ('Pat Johnson', 'XHGOAHEQ'),
           ('Nancy Monreal', 'JKWQPJKL'),
           ('Lynn Blake', 'KLZXWEEE'),
           ('Chen Ke-Hua', 'KWETYCVX'),
           ('Scott Lakso', 'UUEAPQPS'),
           ('Jim Pornot', 'XKJEYAZA');

INSERT INTO services (description, price)
    VALUES ('Unix Hosting', 5.95),
           ('DNS', 4.95),
           ('Whois Registration', 1.95),
           ('High Bandwidth', 15.00),
           ('Business Support', 250.00),
           ('Dedicated Hosting', 50.00),
           ('Bulk Email', 250.00),
           ('One-to-one Training', 999.00);

CREATE TABLE customers_services (
    id serial PRIMARY KEY,
    customer_id integer REFERENCES customers (id) ON DELETE CASCADE NOT NULL,
    service_id integer REFERENCES services (id) NOT NULL,
    UNIQUE(customer_id, service_id)
);

INSERT INTO customers_services (customer_id, service_id)
    VALUES (1, 1), (1, 2), (1, 3), (3, 1), (3, 2),
           (3, 3), (3, 4), (3, 5), (4, 1), (4, 4),
           (5, 1), (5, 2), (5, 6), (6, 1), (6, 6),
           (6, 7);

-- query to return all customers data for each customer that subscribes to >= 1 service
SELECT customers.*
    FROM customers
    INNER JOIN customers_services
        ON customer_id = customers.id;

-- query to return all customers data for each customer that doesn't subscribe to any service
SELECT customers.*
    FROM customers
    LEFT JOIN customers_services
        ON customer_id = customers.id
    WHERE service_id IS NULL;


-- query to return all customers & services data for each customer that doesn't subscribe to any
--   service and all services that don't have any customers
SELECT customers.*, services.*
    FROM customers
    LEFT JOIN customers_services
        ON customer_id = customers.id
    FULL OUTER JOIN services
        ON service_id = services.id
        WHERE customer_id IS NULL
        AND service_id IS NULL;

-- query to return a list of all service(s) that are not currently in use
SELECT services.description
    FROM customers_services
    RIGHT OUTER JOIN services
        ON services.id = service_id
    WHERE customer_id IS NULL;

-- query to return all customers and a corresponding list of services they use
SELECT customers.name, string_agg(services.description, ', ') AS services
    FROM customers
    INNER JOIN customers_services
        ON customer_id = customers.id
    INNER JOIN services
        ON service_id = services.id
    GROUP BY customers.name;

-- query to return the description & count of subscribed customers for each service
--   subscribed to by >= 3 customers
SELECT services.description, count(customer_id)
    FROM services
    LEFT JOIN customers_services
        ON service_id = services.id
    GROUP BY services.description
    HAVING count(customers_services.customer_id) >= 3;

-- aggregate price of all customers' services
SELECT sum(price) AS gross_income
    FROM services
    INNER JOIN customers_services
        ON service_id = services.id
    INNER JOIN customers
        ON customer_id = customers.id;

-- current expected gross income from services that cost >= $100
SELECT sum(price)
    FROM services
    INNER JOIN customers_services
        ON service_id = services.id
    INNER JOIN customers
        ON customer_id = customers.id
    WHERE price >= 100;

-- hypothetical max grows income if all customers purchase all big ticket >= $100 services
SELECT sum(price)
    FROM customers
    CROSS JOIN services -- basically cross multiplying all customer rows with all big ticket service rows
    WHERE price > 100;

-- delete bulk email service and a random customer
SELECT id
    FROM services
    WHERE description = 'Bulk Email'; -- find relevant service_id

DELETE FROM customers_services
    WHERE service_id = 7;

DELETE FROM services
    WHERE id = 7;

DELETE FROM customers
    WHERE name = 'Pat Johnson'; 
    -- corresponding rows in customers_services will automatically be deleted
    --   too b/c set ON CASCADE DELETE
