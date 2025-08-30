-- Relational DB : tables related to one and other
-- DATABASES give us flexibility to keep things organized neatly in their own tables
-- SQL is one of the most popular environments for working with data
-- When writting a query its execution speed depends on the amount of data you are asking the database to read and the number and type of calculation you are asking it to make.
-- When creating a database, it is really important to think about how data will be stored. This is known as normalization,
-- Link for normalization: https://www.itprotoday.com/sql-server/sql-by-design-why-you-need-database-normalization


-- JOINs tells query an additional table from which you would like to pull data

--Inner JOIN

-- JOINs are useful for allowing us to pull data from multiple tables. This is both simple and powerful all at the same time.
SELECT orders.*, accounts.* FROM orders JOIN accounts ON orders.account_id = accounts.id;

-- Try pulling all the data from the accounts table, and all the data from the orders table.
SELECT * FROM accounts JOIN orders ON accounts.id = orders.account_id;

-- Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc from the accounts table.
SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty, accounts.website, accounts.primary_poc FROM orders JOIN accounts ON orders.account_id = accounts.id;

-- primary key. A primary key exists in every table, and it is a column that has a unique value for every row.
-- Foreign Key (FK): A foreign key is a column in one table that is a primary key in a different table. We can see in the Parch & Posey ERD that the foreign keys are
-- Notice our SQL query has the two tables we would like to join - one in the FROM and the other in the JOIN. Then in the ON, we will ALWAYs have the PK equal to the FK

-- Alias
		-- When we JOIN tables together, it is nice to give each table an alias. Frequently an alias is just the first letter of the table name.

		-- Provide a table for all web_events associated with account name of Walmart. There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event. Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.
		SELECT a.primary_poc, w.occurred_at, w.channel, a.name FROM web_events w JOIN accounts a ON w.account_id = a.id WHERE a.name = 'Walmart';

		-- Provide a table that provides the region for each sales_rep along with their associated accounts. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.

		-- If you have two or more columns in your SELECT that have the same name after the table name such as accounts.name and sales_reps.name you will need to alias them. Otherwise it will only show one of the columns. You can alias them like accounts.name AS AcountName, sales_rep.name AS SalesRepName

		-- (incorrect, didn't use column alia with same columns names) SELECT r.name, s.name, a.name FROM region r JOIN sales_reps s ON r.id = s.region_id JOIN accounts a ON s.id = a.sales_rep_id;
		SELECT s.name salesname, r.name regionname, a.name accountname FROM sales_reps s JOIN region r ON s.region_id = r.id JOIN accounts a ON s.id = a.sales_rep_id;

		-- Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. Your final table should have 3 columns: region name, account name, and unit price. A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.
		SELECT r.name regionname, a.name accountname, o.total_amt_usd/(o.total+0.01) unitprice FROM orders o JOIN accounts a ON o.account_id = a.id JOIN sales_reps s ON a.sales_rep_id = s.id JOIN region r ON s.region_id = r.id;
		
		--above is mine written, below is what udacity have in solution
		SELECT r.name region, a.name account, 
           o.total_amt_usd/(o.total + 0.01) unit_price
			FROM region r
			JOIN sales_reps s
			ON s.region_id = r.id
			JOIN accounts a
			ON a.sales_rep_id = s.id
			JOIN orders o
			ON o.account_id = a.id;

--Types of JOINs
	-- Inner JOIN
	-- Left JOIN
	-- Right JOIN
	-- Full Outer JOIN

-- Left and right JOIN are interchangable
-- Left join pulls additional row, If there is not matching information in the JOINed table, then you will have columns with empty cells (null).
 -- Inner JOIN: essentially JOINing the matching PK-FK links from the two tables

-- Inner JOIN:
SELECT c.countryid, c.countryName, s.stateName
FROM Country c
JOIN State s
ON c.countryid = s.countryid;

-- Left JOIN
SELECT c.countryid, c.countryName, s.stateName
FROM Country c
LEFT JOIN State s
ON c.countryid = s.countryid;

-- Pro Tip
	--	Logic in the ON clause reduces the rows befor combining the tables
	--	Logic in the WHERE clause occurs after the JOIN occurs
-- video to watch again: https://learn.udacity.com/ud198?version=2.0.3&lessonKey=a599bc58-1c8e-4be9-9e23-1d4d5b9a921e&conceptKey=e1bcfc2d-decb-4f63-811d-991bcd3807ab


-- Questions
		-- 1. Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
		SELECT region.name region_name, sales_reps.name sales_reps_name, accounts.name account_name FROM accounts JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id JOIN region on sales_reps.region_id = region.id WHERE region.name = 'Midwest' ORDER BY accounts.name ASC;

		-- 2. Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a first name starting with S and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
		SELECT accounts.name accounts_name, sales_reps.name sales_reps_name, region.name region_name FROM accounts JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id JOIN region ON sales_reps.region_id = region.id WHERE sales_reps.name LIKE 'S%' and region.name = 'Midwest' ORDER BY accounts.name ASC;

		-- 3. Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
		SELECT accounts.name account_name, sales_reps.name sales_rep_name, region.name region_name FROM accounts JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id JOIN region ON sales_reps.region_id = region.id WHERE sales_reps.name LIKE '% K%' AND region.name = 'Midwest' ORDER BY accounts.name ASC;

		-- 4. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100. Your final table should have 3 columns: region name, account name, and unit price. In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).
		SELECT region.name region_name, accounts.name account_name, total_amt_usd/(total+0.01) unit_price FROM orders JOIN accounts ON orders.account_id = accounts.id JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id JOIN region ON sales_reps.region_id = region.id WHERE orders.standard_qty > 100;
		

		-- 5. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the smallest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).
		SELECT accounts.name account_name, region.name region_name, total_amt_usd/(total+0.01) unit_price FROM orders JOIN accounts ON orders.account_id = accounts.id JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id JOIN region ON sales_reps.region_id = region.id WHERE standard_qty > 100 AND poster_qty > 50 ORDER BY unit_price ASC;

		-- 6. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the largest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).
		SELECT a.name account_name, r.name region_name, total_amt_usd/(total+0.01) unit_price FROM orders o JOIN accounts a ON o.account_id = a.id JOIN sales_reps sr ON a.sales_rep_id = sr.id JOIN region r ON sr.region_id = r.id WHERE o.standard_qty > 100 and poster_qty > 50 ORDER BY unit_price DESC;

		-- 7. What are the different channels used by account id 1001? Your final table should have only 2 columns: account name and the different channels. You can try SELECT DISTINCT to narrow down the results to only the unique values.
		SELECT DISTINCT a.id, a.name, w.channel FROM accounts a JOIN web_events w ON w.account_id = a.id WHERE a.id = 1001;

		-- 8. Find all the orders that occurred in 2015. Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.
		SELECT o.occurred_at, a.name, o.total, o.total_amt_usd FROM orders o JOIN accounts a ON o.account_id = a.id WHERE o.occurred_at BETWEEN '2015-01-01' AND '2016-01-01';






-- There are a few more advanced JOINs that we did not cover here, and they are used in very specific use cases. UNION and UNION ALL(opens in a new tab), CROSS JOIN(opens in a new tab), and the tricky SELF JOIN(opens in a new tab). 
















-- content: I recommend testing your queries with the environment below, and then saving them to a file. Then compare your file to my solutions on the next concept!
--If you have two or more columns in your SELECT that have the same name after the table name such as accounts.name and sales_reps.name you will need to alias them. Otherwise it will only show one of the columns. You can alias them like accounts.name AS AcountName, sales_rep.name AS SalesRepName
