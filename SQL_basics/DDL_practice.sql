CREATE DATABASE extrasolar;
\c extrasolar

CREATE TABLE stars (
    id serial PRIMARy KEY,
    name varchar(25) UNIQUE NOT NULL,
    distance integer NOT NULL CHECK (distance > 0),
    spectral_type varchar(1),
    companions integer NOT NULL CHECK (companions >= 0)
);

CREATE TABLE planets (
    id serial PRIMARY KEY,
    designation varchar(1),
    mass integer CHECK (mass > 0)
);

-- add relationship between planets and stars:
ALTER TABLE planets
    ADD COLUMN star_id integer NOT NULL
        REFERENCES stars (id);

ALTER TABLE planets
    ALTER COLUMN name TYPE varchar(50);

-- change datatype to allow for any degree of precision
ALTER TABLE stars
    ALTER COLUMN distance TYPE numeric;

ALTER TABLE stars
    ADD CONSTRAINT spectral_type
        CHECK (spectral_type IN ('O', 'B', 'A', 'F', 'G', 'K', 'M')),
    ALTER COLUMN spectral_type SET NOT NULL;

-- restrict values of spectral_type through the column's datatype not through a constraint
ALTER TABLE stars
    DROP CONSTRAINT spectral_type;

CREATE TYPE spectral_type_enum AS ENUM ('O', 'B', 'A', 'F', 'G', 'K', 'M');

ALTER TABLE stars
    ALTER COLUMN spectral_type TYPE spectral_type_enum
        USING spectral_type::spectral_type_enum;

-- setting column and table-level restrictions (check is table-level)
ALTER TABLE planets
    ALTER COLUMN mass TYPE numeric,
    ALTER COLUMN mass SET NOT NULL,
    ADD CHECK (mass > 0.0),
    ALTER COLUMN designation SET NOT NULL;

-- can specify NOT NULL upfront as a constraint, b/c haven't added data yet to planets relation
ALTER TABLE planets
    ADD COLUMN semi_major_axis numeric NOT NULL;

CREATE TABLE moons (
    id serial PRIMARY KEY,
    designation integer NOT NULL CHECK (designation > 0),
    semi_major_axis numeric CHECK (semi_major_axis > 0.0),
    mass numeric CHECK (mass > 0.0),
    planet_id integer NOT NULL REFERENCES planets (id)
);

\c encyclopedia
DROP DATABASE extrasolar;