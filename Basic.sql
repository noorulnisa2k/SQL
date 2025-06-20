
https://docs.google.com/document/d/1Vqp7aGB0dlkty4xCTgR6WewGcMYqU2RMUapFCNeSCmM/edit?tab=t.0

--One way to store data is on Spreedsheet
--Sometimes need alots of spreadsheet to store data from different resources.
--We can Visualize the relationships between these spreadsheets using an ERD
--Which stands for entity relationship diagram.
--SQL terms (SELECT,FROM,LIMIT etc.) called clause


--ORDER BY: SELECT * FROM Orders ORDER BY created_at DESC LIMIT 10;
--By default ORDER BY pick ACS


-- >>> Derived COLUMN: a new column that is a manipulation of the Existing columns in the DATABASE, use AS to give it a new column name (alias).
			SELECT id, (standard_amt_usd/total_amt_usd)*100 AS std_percent, total_amt_usd
			FROM orders
			LIMIT 10;
			
			--Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for standard paper for each order. Limit the results to the first 10 orders, and include the id and account_id fields.
			SELECT id, account_id, standard_amt_usd, standard_qty, standard_amt_usd / standard_qty as new_qty from orders LIMIT 10;

			--Write a query that finds the percentage of revenue that comes from poster paper for each order. You will need to use only the columns that end with _usd. (Try to do this without using the total column.) Display the id and account_id fields also. 
			SELECT id, account_id, poster_amt_usd/(standard_amt_usd+gloss_amt_usd+poster_amt_usd) AS revenue FROM orders limit 10;


-- >>> TEXT Logical Operators: LIKE, IN, NOT, OR, AND & BETWEEN
			-- LIKE Operator:
				-- All the companies whose names start with 'C'.
				SELECT * FROM accounts WHERE name LIKE 'C%';

				-- All companies whose names contain the string 'one' somewhere in the name.
				SELECT * FROM accounts WHERE name LIKE '%one%';

				-- All companies whose names end with 's'.
				SELECT * FROM accounts WHERE name LIKE '%s';

			-- IN Operator:
				-- Use the accounts table to find the account name, primary_poc, and sales_rep_id for Walmart, Target, and Nordstrom.
				SELECT name,primary_poc, sales_rep_id FROM accounts WHERE name in ('Walmart','Target','Nordstrom');

				-- Use the web_events table to find all information regarding individuals who were contacted via the channel of organic or adwords.
				SELECT * FROM web_events WHERE channel IN ('organic', 'adwords');

			-- NOT Operator:
				-- Use the accounts table to find the account name, primary poc, and sales rep id for all stores except Walmart, Target, and Nordstrom.
				SELECT name, primary_poc, sales_rep_id FROM accounts WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

				-- Use the web_events table to find all information regarding individuals who were contacted via any method except using organic or adwords methods.
				SELECT * FROM web_events WHERE channel NOT IN ('organic', 'adwords');

				-- All the companies whose names do not start with 'C'.
				SELECT * FROM accounts WHERE name NOT LIKE 'C%';

				-- All companies whose names do not contain the string 'one' somewhere in the name.
				SELECT * FROM accounts WHERE name NOT LIKE '%one%';

				-- All companies whose names do not end with 's'
				SELECT * FROM accounts WHERE name NOT LIKE 's%';

			-- AND and BETWEEN
				-- Instead of writing :
					-- WHERE column >= 6 AND column <= 10
				-- we can instead write, equivalently:
					-- WHERE column BETWEEN 6 AND 10

				-- Write a query that returns all the orders where the standard_qty is over 1000, the poster_qty is 0, and the gloss_qty is 0.
				SELECT * from orders WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;

				-- Using the accounts table, find all the companies whose names do not start with 'C' and end with 's'
				SELECT name FROM accounts WHERE name not ILIKE 'C%' AND name ILIKE '%s';

				-- Displays the order date and gloss_qty data for all orders where gloss_qty is between 24 and 29. 
				SELECT occurred_at, gloss_qty FROM orders WHERE gloss_qty BETWEEN 24 and 29;

				-- Use the web_events table to find all information regarding individuals who were contacted via the organic or adwords channels, and started their account at any point in 2016, sorted from newest to oldest.
				SELECT * FROM web_events WHERE channel in ('organic', 'adwords') AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01' ORDER BY occurred_at DESC;

			-- OR
				-- Find list of orders ids where either gloss_qty or poster_qty is greater than 4000. Only include the id field in the resulting table
				SELECT id FROM orders WHERE gloss_qty > 4000 OR poster_qty > 4000;

				-- Write a query that returns a list of orders where the standard_qty is zero and either the gloss_qty or poster_qty is over 1000.
				SELECT * FROM orders WHERE standard_qty = 0 AND (gloss_qty > 1000 or poster_qty > 1000);

				-- Find all the company names that start with a 'C' or 'W', and the primary contact contains 'ana' or 'Ana', but it doesn't contain 'eana'.
				SELECT * FROM accounts WHERE (name LIKE 'C%' or name LIKE 'W%') AND (primary_poc ILIKE '%ana%' OR primary_poc ILIKE '%Ana%') AND primary_poc not ILIKE '%eana%';
