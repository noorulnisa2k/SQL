-- Relational DB : tables related to one and other
-- DATABASES give us flexibility to keep things organized neatly in their own tables
-- SQL is one of the most popular environments for working with data
-- When writting a query its execution speed depends on the amount of data you are asking the database to read and the number and type of calculation you are asking it to make.
-- When creating a database, it is really important to think about how data will be stored. This is known as normalization,
-- Link for normalization: https://www.itprotoday.com/sql-server/sql-by-design-why-you-need-database-normalization


-- JOINs tells query an additional table from which you would like to pull data
-- JOINs are useful for allowing us to pull data from multiple tables. This is both simple and powerful all at the same time.
SELECT orders.*, accounts.* FROM orders JOIN accounts ON orders.account_id = accounts.id;

-- Try pulling all the data from the accounts table, and all the data from the orders table.
SELECT * FROM accounts JOIN orders ON accounts.id = orders.account_id;

-- Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc from the accounts table.
SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty, accounts.website, accounts.primary_poc FROM orders JOIN accounts ON orders.account_id = accounts.id;