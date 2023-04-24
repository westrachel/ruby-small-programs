CREATE DATABASE workshop;
\c workshop

CREATE TABLE devices (
    id serial PRIMARY KEY,
    name varchar(40) NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE parts (
    id serial PRIMARY KEY,
    part_number integer UNIQUE NOT NULL,
    device_id integer REFERENCES devices (id)
);

INSERT INTO devices (name)
    VALUES ('Accelerometer'),
           ('Gyroscope');

INSERT INTO parts (part_number, device_id)
    VALUES (27, 1),
           (104, 1),
           (505, 1),
           (1000, 2),
           (11, 2),
           (138, 2),
           (493, 2),
           (702, 2),
           (23, NULL),
           (58, NULL),
           (337, NULL);

SELECT devices.name, parts.part_number
    FROM devices
    INNER JOIN parts
        ON devices.id = parts.device_id;

SELECT *
    FROM parts
    WHERE cast(part_number AS text) LIKE '3%';

SELECT devices.name, count(parts.part_number) AS number_parts
    FROM devices
    INNER JOIN parts
        ON devices.id = parts.device_id
    GROUP BY devices.name
    ORDER BY devices.name ASC;

SELECT part_number, device_id FROM parts
    WHERE device_id IS NULL;

SELECT part_number, device_id FROM parts
    WHERE device_id IS NOT NULL;

INSERT INTO devices (name)
    VALUES ('Dynomitometer');

INSERT INTO parts (part_number, device_id)
    VALUES (42, 3);

SELECT name AS oldest_device
    FROM devices
    ORDER BY created_at ASC
    LIMIT 1;

UPDATE parts SET device_id = 1
    WHERE part_number = 37 OR part_number=39;

DELETE FROM parts 
    WHERE device_id = 1;

DELETE FROM devices
    WHERE name = 'Accelerometer';
