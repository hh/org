-- I want to import the above csv into pg
-- Blocked by pg container
-- placeholder sql

create table company_asn  (asn varchar, name varchar);
COPY company_asn from '/tmp/potaroo.csv' DELIMITER ',' CSV;
