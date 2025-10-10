
--this lesson is focused on three topics
		-- Subqueries
		-- Table Expressions
		-- Persistent Derived Tables


-- QUIZE
		-- 
		SELECT channel, AVG(channel_count) 
		FROM (
			SELECT DATE_TRUNC('day', occurred_at), channel, COUNT(*) as channel_count 
			FROM web_events 
			GROUP BY 1, 2 
			ORDER BY 3 DESC
			) table1 
		GROUP BY channel 
		ORDER BY 2 DESC;

-- well formation of query
-- if you are only returning a single value, you might use that value in a logical statement like WHERE, HAVING, or even SELECT - the value could be nested within a CASE statement.
-- 


-- QUIZE
		--1. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
			

		--2. For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?
			

		--3. How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?


		--4. For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?


		--5. What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?


		--6. What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders.





-- CTA
		-- The WITH statement is often called a Common Table Expression or CTE. Though these expressions serve the exact same purpose as subqueries, they are more common in practice, as they tend to be cleaner for a future reader to follow the logic.