-- In this lesson, you will be learning a number of techniques to

-- Clean and re-structure messy data.
-- Convert columns to different data types.
-- Tricks for manipulating NULLs.
-- This will give you a robust toolkit to get from raw data to clean data that's useful for analysis.

-- three new functions
-- LEFT(phone_number, 3).
-- RIGHT(phone_number, 8).
-- LENGTH(phone_number).

-- QUIZE

		--1 In the accounts table, there is a column holding the website for each company. The last three digits specify what type of web address they are using. A list of extensions (and pricing) is provided here(opens in a new tab). Pull these extensions and provide how many of each website type exist in the accounts table.
			SELECT RIGHT(a.website, 3) extension, COUNT(*) FROM accounts a GROUP BY 1 ORDER BY 2 DESC;


		--2 There is much debate about how much the name (or even the first letter of a company name)(opens in a new tab) matters. Use the accounts table to pull the first letter of each company name to see the distribution of company names that begin with each letter (or number).
			SELECT LEFT(UPPER(name), 1), COUNT(*) FROM accounts a GROUP BY 1 ORDER BY 2 DESC;


		--3 Use the accounts table and a CASE statement to create two groups: one group of company names that start with a number and a second group of those company names that start with a letter. What proportion of company names start with a letter?
			SELECT SUM(t1.num) num, SUM(t1.letter) letter 
			FROM

				(SELECT name, 
				CASE WHEN LEFT(a.name,1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 1
				ELSE 0 END num,
				 CASE WHEN LEFT(a.name,1) NOT IN ('0','1','2','3','4','5','6','7','8','9') THEN 1
				ELSE 0
				END letter 
				FROM accounts a) t1;

		--4 Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else?
			SELECT SUM(t1.volv_start) volv_start, SUM(t1.other_start) other_start 
			FROM 
				(SELECT a.name, 
				CASE WHEN LEFT(LOWER(a.name), 1) IN ('a', 'e', 'i', 'o', 'u') THEN 1 ELSE 0 END volv_start, 
				CASE WHEN LEFT(LOWER(a.name), 1) NOT IN ('a', 'e', 'i', 'o', 'u') THEN 1 ELSE 0 END other_start 
				FROM accounts a) t1;

-- More functions:
		-- POSITION
		-- STRPOS
		-- LOWER
		-- UPPER


-- QUIZE
		-- Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.
			SELECT primary_poc, 
			LEFT(primary_poc, STRPOS(primary_poc, ' ')-1) first_name, 
			RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc,' ')) last_name
			FROM accounts;

		-- Now see if you can do the same thing for every rep name in the sales_reps table. Again provide first and last name columns.
			SELECT name, LEFT(name, STRPOS(name, ' ') -1) first_name,
			RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) last_name
			FROM sales_reps;

-- CONCAT
		-- REPLACE
		-- CONCAT
		-- Piping ||
				-- both can be used to concatenate strings together

				-- CONCAT(first_name, ' ', last_name) or with piping as first_name || ' ' || last_name.

-- QUIZE
		--1. Each company in the accounts table wants to create an email address for each primary_poc. The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.
			WITH t1 AS (SELECT name, primary_poc, LEFT(primary_poc, STRPOS(primary_poc, ' ') -1) first_name, 
						RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
						FROM accounts)

			SELECT name, primary_poc,
			LOWER(CONCAT(first_name, '.', last_name, '@', name, '.com')) email FROM t1;

		--2. You may have noticed that in the previous solution some of the company names include spaces, which will certainly not work in an email address. See if you can create an email address that will work by removing all of the spaces in the account name, but otherwise your solution should be just as in question 1. Some helpful documentation is here(opens in a new tab).
			WITH t1 AS (SELECT name, primary_poc, LEFT(primary_poc, STRPOS(primary_poc, ' ') -1) first_name, 
						RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
						FROM accounts)

			SELECT name, primary_poc,
			REPLACE(LOWER(CONCAT(first_name, '.', last_name, '@', name, '.com')), ' ', '') email FROM t1;


		--3. We would also like to create an initial password, which they will change after their first log in. The first password will be the first letter of the primary_poc's first name (lowercase), then the last letter of their first name (lowercase), the first letter of their last name (lowercase), the last letter of their last name (lowercase), the number of letters in their first name, the number of letters in their last name, and then the name of the company they are working with, all capitalized with no spaces.
			WITH t1 AS (SELECT name, primary_poc, LEFT(primary_poc, STRPOS(primary_poc, ' ') -1) first_name, 
						RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
						FROM accounts)
							  
			SELECT first_name, last_name, REPLACE(LOWER(CONCAT(first_name, '.', last_name, '@', name, '.com')), ' ', '') email,
							  LOWER( LEFT(first_name, 1) || RIGHT(first_name, 1) || LEFT(last_name,1) || RIGHT(last_name, 1) ) || LENGTH(first_name) || LENGTH(last_name) || REPLACE(UPPER(name), ' ', '') password FROM t1;


-- CAST
		-- TO_DATE
		-- CAST
		-- Casting with ::

	-- Remeber Dates in SQL are stored YYYY-MM-DD
	-- CAST allow to change column from one  data type to other
	-- CAST(date_column AS DATE)
	-- date_column::DATE
	-- TRIM : it can be used to remove characters from the beginning and end of a string. This can remove unwanted spaces at the beginning or end of a row
	-- TRIM format: 
	-- SUBSTR(string, start_position, length)

-- QUIZE solution
		WITH t1 AS (SELECT date, SUBSTR(date, 1, 2) mm, SUBSTR(date, 4, 2) dd, SUBSTR(date, 7, 4) yy FROM sf_crime_data LIMIT 10)

		SELECT date, (yy || '-' || mm || '-' || dd)::DATE date_atl FROM t1;

-------------------------------------------------


-- COALESCE

SELECT *, COALESCE(o.account_id, a.id)
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

