CREATE DATABASE auction;
\c auction

CREATE TABLE bidders (
    id serial PRIMARY KEY,
    name text NOT NULL
);

CREATE TABLE items (
    id serial PRIMARY KEY,
    name text NOT NULL,
    initial_price decimal(6, 2) NOT NULL CHECK(initial_price BETWEEN 0.01 AND 1000.00),
    sales_price decimal(6, 2) CHECK(sales_price BETWEEN 0.01 AND 1000.00)
);

CREATE TABLE bids (
    id serial PRIMARY KEY,
    bidder_id integer NOT NULL REFERENCES bidders(id) ON DELETE CASCADE,
    item_id integer NOT NULL REFERENCES items(id) ON DELETE CASCADE,
    amount numeric(6, 2) NOT NULL CHECK(amount BETWEEN 0.01 and 1000.00)
);

-- create composite index on both bidder_id and item_id
CREATE INDEX ON bids (bidder_id, item_id);

-- can copy in data from a csv
\copy bidders FROM 'bidders.csv' WITH HEADER CSV;
\copy items FROM 'items.csv' WITH HEADER CSV;
\copy bids FROM 'bids.csv' WITH HEADER CSV;

-- subquery to find all items that have bids
SELECT name AS "Bid On Items"
    FROM items
    WHERE id IN
      (SELECT DISTINCT item_id AS id FROM bids);

-- query to find all items that have bids using join not subquery
SELECT DISTINCT name AS "Bid On Items"
    FROM items
    RIGHT JOIN bids
        ON bids.item_id = items.id;

-- explain analyze to show total time for join and subquery approaches
EXPLAIN ANALYZE SELECT name AS "Bid On Items"
    FROM items
    WHERE id IN
      (SELECT DISTINCT item_id AS id FROM bids);

EXPLAIN ANALYZE SELECT DISTINCT name AS "Bid On Items"
    FROM items
    RIGHT JOIN bids
        ON bids.item_id = items.id;

-- subquery approach total cost = 58.71, total time (execution + planning) = 0.261 ms
-- join approach total cost = 81.44, total time =  0.266 ms

-- subquery to find all items not bid on
SELECT name AS "No Bids"
    FROM items
    WHERE id NOT IN
      (SELECT DISTINCT item_id AS id FROM bids);

-- query to find all items w/ no bids using join
SELECT name AS "No Bids"
    FROM items
    FULL JOIN bids
        ON items.id = bids.item_id
    WHERE bidder_id IS NULL;

-- subquery to find names of all active bidders (>= 1 bid)
SELECT name
    FROM bidders
    WHERE EXISTS
      (SELECT bidder_id FROM bids WHERE bidders.id = bids.bidder_id);

-- query to find names of all active bidders using a join
SELECT DISTINCT name
    FROM bidders
    INNER JOIN bids
        ON bidders.id = bids.bidder_id;

-- subquery to find the lgest # of bids from an individual bidder
SELECT max(total_bids.count) FROM
    (SELECT count(id) FROM bids GROUP BY bidder_id) AS total_bids; -- must add alias to virtual table returned by subquery
    

-- scalar subquery to find name of each item bid on and the # of bids they've received
SELECT name,
    (SELECT count(item_id) FROM bids WHERE items.id = item_id)
    FROM items;

-- check that certain data exists by returning id number w/o using AND keyword
SELECT ROW (items.id)
    FROM items
    WHERE ROW(name, initial_price, sales_price) =
        ROW('Painting', 100.00, 250.00);
