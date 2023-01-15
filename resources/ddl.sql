CREATE SCHEMA IF NOT EXISTS sales;

CREATE TABLE IF NOT EXISTS sales.order (
id int PRIMARY KEY,
quantity int NOT NULL,
description text
);