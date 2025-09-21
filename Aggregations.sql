


-- NULLs are a datatype that specifies where no data exists in SQL different from zero and space. They are often ignored in our aggregation functions, which you will get a first look at in the next concept using COUNT.

-- Aggregation - COUNT
	SELECT COUNT(*) FROM accounts;
	SELECT COUNT(id) FROM accounts;
	-- COUNT does not consider rows that have NULL values. Therefore, this can be useful for quickly identifying which rows have missing data.

-- SUM 
	-- Unlike COUNT, you can only use SUM on numeric columns. However, SUM will ignore NULL values,


QUIZE:
	-- Find the total amount of poster_qty paper ordered in the orders table
	SELECT SUM(poster_qty) poster_qty_total FROM orders;

	-- Find the total amount of standard_qty paper ordered in the orders table.
	SELECT SUM(standard_qty) standard_qty_total FROM orders;

	-- Find the total dollar amount of sales using the total_amt_usd in the orders table.
	SELECT SUM(total_amt_usd) amount_total FROM orders;


	--Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. This should give a dollar amount for each order in the table.
	SELECT SUM(standard_amt_usd) standard_amt_usd_total, SUM(gloss_amt_usd) gloss_amt_usd_total FROM orders;
	 -- above one is incorrect, below is the correct:
	SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss
	FROM orders;

	-- Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an aggregation and a mathematical operator.
	SELECT standard_amt_usd, standard_qty FROM orders;
	SELECT SUM(standard_amt_usd)/SUM(standard_qty) per_unit_amt FROM orders;

-- MIN and MAX
	-- Functionally, MIN and MAX are similar to COUNT in that they can be used on non-numerical columns. Depending on the column type, MIN will return the lowest number, earliest date, or non-numerical value as early in the alphabet as possible. As you might suspect, MAX does the opposite—it returns the highest number, the latest date, or the non-numerical value closest alphabetically to “Z.”

-- AVG
	-- Similar to other software AVG returns the mean of the data - that is the sum of all of the values in the column divided by the number of values in a column. 

-- QUIZE
	--1. When was the earliest order ever placed? You only need to return the date.
			SELECT MIN(occurred_at) earliest_order FROM orders;

	--2. Try performing the same query as in question 1 without using an aggregation function.
			SELECT occurred_at earliest_order FROM orders ORDER BY earliest_order ASC LIMIT 1;

	--3. When did the most recent (latest) web_event occur?
			SELECT MAX(occurred_at) latest_web_event FROM web_events;

	--4. Try to perform the result of the previous query without using an aggregation function.
			SELECT occurred_at latest_web_event FROM web_events ORDER BY latest_web_event DESC LIMIT 1;

	--5. Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order. Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.
	SELECT AVG(standard_qty) mean_standard, AVG(gloss_qty) mean_gloss, 
              AVG(poster_qty) mean_poster, AVG(standard_amt_usd) mean_standard_usd, 
              AVG(gloss_amt_usd) mean_gloss_usd, AVG(poster_amt_usd) mean_poster_usd
FROM orders;

	--6. Via the video, you might be interested in how to calculate the MEDIAN. Though this is more advanced than what we have covered so far try finding - what is the MEDIAN total_usd spent on all orders?
	SELECT *
	FROM (SELECT total_amt_usd
			 FROM orders
			 ORDER BY total_amt_usd
			 LIMIT 3457) AS Table1
	ORDER BY total_amt_usd DESC
	LIMIT 2;


-- GROUP BY
		-- allow creating segments that will aggregate independent from one another

		-- The key takeaways here:

				-- GROUP BY can be used to aggregate data within subsets of the data. For example, grouping for different accounts, different regions, or different sales representatives.
				-- Any column in the SELECT statement that is not within an aggregator must be in the GROUP BY clause.
				-- The GROUP BY always goes between WHERE and ORDER BY.
				-- ORDER BY works like SORT in spreadsheet software.
				-- In SQL (ANSI standard, and especially in MySQL/PostgreSQL in strict modes), every non-aggregated column in the SELECT must appear in the GROUP BY.

		-- QUIZE
			
			--1. Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.
					SELECT o.occurred_at order_data, a.name account_name FROM orders o JOIN accounts a ON o.account_id = a.id ORDER BY occurred_at LIMIT 1 ;

			--2. Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name.
					SELECT account_id, a.name, SUM(o.total_amt_usd) FROM orders o JOIN accounts a ON o.account_id = a.id GROUP BY o.account_id, a.name;

			--3.Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? Your query should return only three values - the date, channel, and account name.
					SELECT w.id, w.occurred_at, w.channel, a.name FROM web_events w JOIN accounts a ON w.account_id = a.id ORDER BY occurred_at DESC LIMIT 1;

			--4. Find the total number of times each type of channel from the web_events was used. Your final table should have two columns - the channel and the number of times the channel was used.
					SELECT channel, COUNT(channel) FROM web_events GROUP BY channel;

			--5. Who was the primary contact associated with the earliest web_event?
					SELECT a.primary_poc
					FROM web_events w
					JOIN accounts a
					ON a.id = w.account_id
					ORDER BY w.occurred_at
					LIMIT 1;

			--6. What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.
					SELECT a.name account_name, o.total_amt_usd FROM orders o JOIN accounts a ON o.account_id = a.id ORDER BY total_amt_usd;

					-- above is incorrect, below is the correct answer
					SELECT a.name, MIN(total_amt_usd) smallest_order
					FROM accounts a
					JOIN orders o
					ON a.id = o.account_id
					GROUP BY a.name
					ORDER BY smallest_order;

			--7. Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.
					SELECT r.name region_name, COUNT(sr.id)  num_reps FROM region r JOIN sales_reps sr ON r.id = sr.region_id GROUP BY region_name ORDER BY num_reps;



-- GROUP BY II

		-- GROUP BY and ORDER BY can be used with multiple columns in the same query

		-- You can GROUP BY multiple columns at once, as we showed here. This is often useful to aggregate across a number of different segments.

		-- The order of columns listed in the ORDER BY clause does make a difference. You are ordering the columns from left to right.

		-- QUIZE: GROUP BY II

			--1. For each account, determine the average amount of each type of paper they purchased across their orders. Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account.
			SELECT a.name, AVG(standard_qty) std_qty, AVG(gloss_qty) gls_qty, AVG(poster_qty) ptr_qty FROM orders o JOIN accounts a ON o.account_id = a.id GROUP BY a.name ;

			--2. For each account, determine the average amount spent per order on each paper type. Your result should have four columns - one for the account name and one for the average amount spent on each paper type.
			SELECT a.name, AVG(standard_amt_usd) standard_amt, AVG(gloss_amt_usd) gloss_amt, AVG(poster_amt_usd) poster_amt from accounts a JOIN orders o ON a.id = o.account_id GROUP BY a.name;

			--3. Determine the number of times a particular channel was used in the web_events table for each sales rep. Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
			SELECT sr.name sales_rep_name, w.channel, COUNT(w.channel) channel_count 
			FROM web_events w 
			JOIN accounts a 
			ON w.account_id = a.id 
			JOIN sales_reps sr 
			ON sr.id = a.sales_rep_id 
			GROUP BY sales_rep_name, w.channel ORDER BY channel_count DESC;

			--4. Determine the number of times a particular channel was used in the web_events table for each region. Your final table should have three columns - the region name, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
			SELECT r.name, w.channel, COUNT(*) channel_count
			FROM accounts a
			JOIN web_events w 
			ON a.id = w.account_id
			JOIN sales_reps s
			ON a.sales_rep_id = s.id
			JOIN region r 
			ON s.region_id = r.id 
			GROUP BY r.name, w.channel 
			ORDER BY channel_count DESC;

--DISTINCT
	-- It’s worth noting that using DISTINCT, particularly in aggregations, can slow your queries down quite a bit.

	-- QUIZE
			--1. Use DISTINCT to test if there are any accounts associated with more than one region.
				SELECT DISTINCT a.name account_name, r.name region_name 
				FROM accounts a 
				JOIN sales_reps s 
				ON a.sales_rep_id = s.id 
				JOIN region r 
				ON r.id = s.region_id;


			--2. Have any sales reps worked on more than one account?
				SELECT DISTINCT a.name account_name, s.name sales_rep_name 
				FROM accounts a 
				JOIN sales_reps s 
				ON a.sales_rep_id = s.id;



--HAVING
	-- HAVING is the “clean” way to filter a query that has been aggregated, but this is also commonly done using a subquery(opens in a new tab). 
	-- Essentially, any time you want to perform a WHERE on an element of your query that was created by an aggregate, you need to use HAVING instead.
	
	-- QUIZE

		--1. How many of the sales reps have more than 5 accounts that they manage?
			SELECT s.id s_id, s.name s_name , COUNT(s.id) s_id_count 
			FROM accounts a 
			JOIN sales_reps s 
			ON a.sales_rep_id = s.id 
			GROUP BY s_id, s_name 
			HAVING COUNT(s.id) > 5 
			ORDER BY s_id_count DESC;

		--2. How many accounts have more than 20 orders?
			SELECT a.name, a.id a_id, COUNT(*) order_count 
			FROM accounts a 
			JOIN orders o 
			ON a.id = o.account_id 
			GROUP BY a.name, a.id 
			HAVING COUNT(*) > 20 
			ORDER BY order_count;

		--3. Which account has the most orders?
			SELECT a.id, a.name, COUNT(*) order_count 
			FROM accounts a 
			JOIN orders o 
			ON a.id = o.account_id 
			GROUP BY a.id, a.name 
			ORDER BY order_count DESC 
			LIMIT 1;

		--4. Which accounts spent more than 30,000 usd total across all orders?
			SELECT a.id, a.name, SUM(total_amt_usd) total_spent 
			FROM accounts a 
			JOIN orders o 
			ON a.id = o.account_id 
			GROUP BY a.id, a.name 
			HAVING SUM(total_amt_usd) > 30000 
			ORDER BY total_spent;


		--5. Which accounts spent less than 1,000 usd total across all orders?
			SELECT a.name, SUM(total_amt_usd) total_spent 
			FROM accounts a 
			JOIN orders o 
			ON a.id = o.account_id 
			GROUP BY a.name 
			HAVING SUM(total_amt_usd) < 1000 
			ORDER BY total_spent;

		--6. Which account has spent the most with us?
			SELECT a.name, SUM(o.total_amt_usd) total_spent 
			FROM accounts a 
			JOIN orders o 
			ON a.id = o.account_id 
			GROUP BY a.name 
			ORDER BY total_spent DESC LIMIT 1;

		--7. Which account has spent the least with us?
			SELECT a.name, SUM(total_amt_usd) total_spent 
			FROM accounts a 
			JOIN orders o 
			ON a.id = o.account_id 
			GROUP BY a.name 
			ORDER BY total_spent LIMIT 1;

		--8. Which accounts used facebook as a channel to contact customers more than 6 times?
			SELECT a.name, w.channel, COUNT(*) occurrence 
			FROM accounts a 
			JOIN web_events w 
			ON a.id = w.account_id 
			GROUP BY a.name, w.channel 
			HAVING COUNT(*) > 6 AND w.channel = 'facebook' 
			ORDER BY occurrence;

		--9. Which account used facebook most as a channel?
			SELECT a.name, w.channel, COUNT(w.channel) occurrence 
			FROM accounts a 
			JOIN web_events w 
			ON a.id = w.account_id 
			WHERE w.channel = 'facebook' 
			GROUP BY a.name, w.channel 
			ORDER BY occurrence DESC 
			LIMIT 1;

		--10. Which channel was most frequently used by most accounts?
			SELECT a.name, w.channel, COUNT(*) occurrence 
			FROM accounts a 
			JOIN web_events w 
			ON a.id = w.account_id 
			GROUP BY a.name, w.channel 
			ORDER BY occurrence DESC 
			LIMIT 10;



-- Date Function (DATE_TRUNC, DATE_PART, etc.)

		--1. Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?
			SELECT DATE_PART('year', occurred_at), SUM(total_amt_usd) 
			FROM orders 
			GROUP BY 1 
			ORDER BY 1;

		--2. Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?
			SELECT DATE_PART('month', occurred_at), SUM(total_amt_usd) 
			FROM orders 
			GROUP BY 1 
			ORDER BY 2 DESC;

		--3. Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly represented by the dataset?
			SELECT DATE_PART('year', occurred_at), COUNT(*) 
			FROM orders 
			GROUP BY 1 
			ORDER BY 1;

		--4. Which month did Parch & Posey have the greatest sales in terms of total number of orders? Are all months evenly represented by the dataset?
			SELECT DATE_PART('month', occurred_at) ord_month, COUNT(*) total_sales
			FROM orders
			WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
			GROUP BY 1
			ORDER BY 2 DESC; 

		--5. In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
			SELECT DATE_TRUNC('month', o.occurred_at) accurred_date, SUM(o.gloss_amt_usd) 
			FROM orders o 
			JOIN accounts a 
			ON o.account_id = a.id 
			WHERE a.name = 'Walmart' 
			GROUP BY 1 
			ORDER BY 2 DESC 
			LIMIT 1;


-- DERIVE
		-- Take data from existing columns and modify them
		-- previously we did this using arithmetic
		-- PRO TIP: case statement handles "IF" "THEN" logic
		-- the case statement is followed by at least one pair of "WHEN" and "THEN" statement
		-- CASE statement must end with the word "END"


		-- QUIZE

			--1. Write a query to display for each order, the account ID, total amount of the order, and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000.
				SELECT o.account_id, o.total_amt_usd, 
				CASE WHEN o.total_amt_usd >= 3000 THEN 'Large' 
				ELSE 'Small' END level 
				FROM orders o;

			--2. Write a query to display the number of orders in each of three categories, based on the total number of items in each order. The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.
				SELECT CASE WHEN total >= 2000 THEN 'at least' 
				WHEN total BETWEEN 1000 and 2000 THEN 'between' 
				WHEN total < 1000 THEN 'less then' END category, 
				COUNT(*) order_count 
				FROM orders 
				GROUP BY 1;

			--3. We would like to understand 3 different levels of customers based on the amount associated with their purchases. The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd. Provide a table that includes the level associated with each account. You should provide the account name, the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.
				SELECT a.name, SUM(total_amt_usd) total_spend, 
				CASE WHEN SUM(total_amt_usd) > 200000 THEN 'Life time' 
				WHEN SUM(total_amt_usd) BETWEEN 200000 and 100000 THEN 'Second' 
				WHEN SUM(total_amt_usd) < 100000 THEN 'Third' END level 
				FROM orders o 
				JOIN accounts a 
				ON o.account_id = a.id 
				GROUP BY a.name 
				ORDER BY 2 DESC;

			--4. We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent by customers only in 2016 and 2017. Keep the same levels as in the previous question. Order with the top spending customers listed first.
				SELECT a.name, SUM(total_amt_usd) total_spent, 
				CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top' 
				WHEN SUM(total_amt_usd) < 200000 and SUM(total_amt_usd) > 100000 THEN 'middle' 
				WHEN SUM(total_amt_usd) < 100000 THEN 'last' END level 
				FROM orders o 
				JOIN accounts a 
				ON o.account_id = a.id 
				WHERE DATE_PART('year', o.occurred_at) in ('2016', '2017') 
				GROUP BY a.name 
				ORDER BY 2 DESC;

			--5. We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if they have more than 200 orders. Place the top sales people first in your final table.
				SELECT s.name sales_name, COUNT(*), 
				CASE WHEN COUNT(s.name) > 200 THEN 'top' 
				ELSE 'not' END level 
				FROM sales_reps s 
				JOIN accounts a 
				ON s.id = a.sales_rep_id 
				JOIN orders o 
				ON a.id = o.account_id 
				GROUP BY s.name 
				ORDER BY 2 DESC;

			--6. The previous didn't account for the middle, nor the dollar amount associated with the sales. Management decides they want to see these characteristics represented as well. We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales. Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column with top, middle, or low depending on this criteria. Place the top sales people based on dollar amount of sales first in your final table. You might see a few upset sales people by this criteria!
				SELECT s.name, COUNT(s.name) total_orders, SUM(o.total_amt_usd) total_sales_count,
				CASE WHEN COUNT(s.name) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top'
				WHEN COUNT(s.name) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'middle'
				ELSE 'low' END level
				FROM sales_reps s 
				JOIN accounts a 
				ON s.id = a.sales_rep_id 
				JOIN orders o 
				ON a.id = o.account_id 
				GROUP BY s.name 
				ORDER BY 3 DESC;



 


-- Content for NULL

	--https://learn.udacity.com/ud198?version=2.0.3&lessonKey=5761d1b7-6bb2-496c-8512-a610649884d7&conceptKey=6f9c464a-8cec-4287-b6bb-ec9abf74c94c