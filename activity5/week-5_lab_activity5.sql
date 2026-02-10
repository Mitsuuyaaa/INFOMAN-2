
-- Part 1
SELECT COUNT(*) FROM your_table_name;


-- Part 2
SELECT * FROM products WHERE product_code = 'bxpy';

EXPLAIN ANALYZE SELECT * FROM products WHERE product_code = 'bxpy';

-- Part 3
CREATE INDEX idx_products_product_code ON products(product_code);

EXPLAIN ANALYZE SELECT * FROM products WHERE product_code = 'bxpy';

--Part 4
INSERT INTO products (name, description, price, product_code, stock, added)
SELECT 'product_' || i,
        'description_' || i,
        i*10.0,
        'code_' || i,
        100,
        now()
        FROM generate_series(1,100000) AS s(i);



* Analysis Questions *
Initial Data Insertion Time (100,000 rows): 932 ms
Query Execution Time (Non-Indexed): 12.302 ms
Query Execution Time (Indexed): 0.085 ms
Single Row Insertion Time (With Index): ~0.1–0.2 ms

1. How did the query execution time change after creating the index? Was it faster or slower? By approximately how much?

After creating the index on product_code, the query became much faster.
Before the index: 12.302 ms
After the index: 0.085 ms
It got faster by about 12 ms, which is roughly 145 times faster.

2. Why do you think the query performance changed as you observed?

The query got faster because the index lets PostgreSQL find the rows directly instead of looking through every row one by one. 
Before the index, it had to check all 100,000 rows (sequential scan). 
With the index, it only looked at the rows that matched.

3. What is the trade-off of having an index on a table?

Indexes make reading/querying data faster, but they make inserting or updating data a little slower because PostgreSQL 
has to also update the index. That’s why inserting a single row after adding the index takes slightly more time than 
inserting into a table without an index.

