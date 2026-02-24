

## Query Analysis and Optimization


### Scenario 1: The Slow Author Profile Page

**Before Query Plan and Execution times**
```txt
                                                 QUERY PLAN
-------------------------------------------------------------------------------------------------------------
 Sort  (cost=635.38..635.42 rows=18 width=56) (actual time=1.422..1.424 rows=17.00 loops=1)
   Sort Key: date DESC
   Sort Method: quicksort  Memory: 26kB
   Buffers: shared hit=510
   ->  Seq Scan on posts  (cost=0.00..635.00 rows=18 width=56) (actual time=0.061..1.404 rows=17.00 loops=1)
         Filter: (author_id = 42)
         Rows Removed by Filter: 9983
         Buffers: shared hit=510
 Planning:
   Buffers: shared hit=5
 Planning Time: 0.919 ms
 Execution Time: 1.444 ms
(12 rows)
```


**Query:**
```sql
EXPLAIN ANALYZE
SELECT id, title
FROM posts
WHERE author_id = 42
ORDER BY date DESC;   

```

**Analysis Questions:**
*   What is the primary node causing the slowness in the initial execution plan?
<u>The main bottleneck is a Sequential Scan (Seq Scan) on the posts table. PostgreSQL scans all ~10,000 rows because there is no index on author_id.</u>
*   How can you optimize both the `WHERE` clause filtering and the `ORDER BY` operation with a single change?
<u>Create a composite index on (author_id, date DESC).
This allows PostgreSQL to filter by author and return rows already sorted by date.</u>
*   Implement your fix and record the new plan. How much faster is the query now?
<u>CREATE INDEX idx_posts_author_date
ON posts (author_id, date DESC);</u>

**After Query Plan and Execution times**
```txt
                                                               QUERY PLAN                                               
-----------------------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=66.88..66.92 rows=18 width=56) (actual time=0.262..0.264 rows=17.00 loops=1)
   Sort Key: date DESC
   Sort Method: quicksort  Memory: 26kB
   Buffers: shared hit=17 read=2
   ->  Bitmap Heap Scan on posts  (cost=4.42..66.50 rows=18 width=56) (actual time=0.165..0.225 rows=17.00 loops=1)
         Recheck Cond: (author_id = 42)
         Heap Blocks: exact=17
         Buffers: shared hit=17 read=2
         ->  Bitmap Index Scan on idx_posts_author_date  (cost=0.00..4.42 rows=18 width=0) (actual time=0.123..0.123 rows=17.00 loops=1)
               Index Cond: (author_id = 42)
               Index Searches: 1
               Buffers: shared read=2
 Planning:
   Buffers: shared hit=18 read=1
 Planning Time: 2.660 ms
 Execution Time: 0.313 ms
(16 rows)
```

### Scenario 2: The Unsearchable Blog

**Before Query Plan and Execution times**
```txt
                                              QUERY PLAN
-----------------------------------------------------------------------------------------------------
 Seq Scan on posts  (cost=0.00..635.00 rows=1 width=52) (actual time=4.062..4.064 rows=0.00 loops=1)
   Filter: ((title)::text ~~ '%database%'::text)
   Rows Removed by Filter: 10000
   Buffers: shared hit=510
 Planning Time: 0.202 ms
 Execution Time: 4.085 ms
(6 rows)
```


**Query:**
```sql
EXPLAIN ANALYZE
SELECT id, title
FROM posts
WHERE title LIKE '%database%';
```

**Analysis Questions:**
*   First, try adding a standard B-Tree index on the `title` column. Run `EXPLAIN ANALYZE` again. Did the planner use your index? Why or why not?
<u>No, the planner did not use the index when searching with LIKE '%database%'. This is because the pattern starts with a wildcard %, so PostgreSQL cannot use the B-Tree to jump to the relevant rows. It must scan every row sequentially to check the condition.</u>
*   The business team agrees that searching by a *prefix* is acceptable for the first version. Rewrite the query to use a prefix search (e.g., `database%`).
<u>EXPLAIN ANALYZE
SELECT id, title
FROM posts
WHERE title LIKE 'database%';</u>
*   Does the index work for the prefix-style query? Explain the difference in the execution plan.
<u>Yes. Because the query now has a known starting string ('database%'), PostgreSQL can traverse the B-Tree index efficiently using an Index Scan. This avoids scanning all rows sequentially. The execution plan will show Index Scan using idx_posts_title instead of Seq Scan, drastically reducing execution time.</u>

**After Query Plan and Execution times**
```txt
                                             QUERY PLAN
-----------------------------------------------------------------------------------------------------
 Seq Scan on posts  (cost=0.00..635.00 rows=1 width=52) (actual time=1.247..1.248 rows=0.00 loops=1)
   Filter: ((title)::text ~~ 'database%'::text)
   Rows Removed by Filter: 10000
   Buffers: shared hit=510
 Planning:
   Buffers: shared hit=16 read=1
 Planning Time: 3.087 ms
 Execution Time: 1.267 ms
(8 rows)
```

### Scenario 3: The Monthly Performance Report

**Before Query Plan and Execution times**
```txt
                                              QUERY PLAN
-------------------------------------------------------------------------------------------------------
 Seq Scan on posts  (cost=0.00..710.00 rows=1 width=374) (actual time=1.194..4.674 rows=22.00 loops=1)
   Filter: ((EXTRACT(month FROM date) = '1'::numeric) AND (EXTRACT(year FROM date) = '2015'::numeric))
   Rows Removed by Filter: 9978
   Buffers: shared hit=510
 Planning:
   Buffers: shared hit=16 dirtied=1
 Planning Time: 1.385 ms
 Execution Time: 4.697 ms
(8 rows)

```


**Query:**
```sql
--- Provide the query
```

**Analysis Questions:**
*   This query is not S-ARGable. What does that mean in the context of this query? Why can't the query planner use a simple index on the `date` column effectively?
<u>The query is not S-ARGable because it applies a function (EXTRACT(MONTH FROM date) and EXTRACT(YEAR FROM date)) to the date column. PostgreSQL cannot use a standard B-Tree index on date in this case, because the function transforms the column value, making it impossible to directly compare using the index. As a result, the planner must perform a sequential scan of the entire table.</u>
*   Rewrite the query to use a direct date range comparison, making it S-ARGable.
<u>SELECT *
FROM posts
WHERE date >= '2015-01-01'
  AND date < '2015-02-01';</u>
*   Create an appropriate index to support your rewritten query.
<u>CREATE INDEX idx_posts_date ON posts(date);</u>
*   Compare the performance of the original query and your optimized version.
<u>The original query with EXTRACT required a sequential scan and took about 4.697 ms. The optimized query using a direct date range and the index scan executes in 0.216 ms, roughly 10× faster.</u>

**After Query Plan and Execution times**
```txt
                                                         QUERY PLAN                                                     
----------------------------------------------------------------------------------------------------------------------------
 Bitmap Heap Scan on posts  (cost=4.45..60.19 rows=16 width=374) (actual time=0.152..0.185 rows=22.00 loops=1)
   Recheck Cond: ((date >= '2015-01-01'::date) AND (date < '2015-02-01'::date))
   Heap Blocks: exact=22
   Buffers: shared hit=22 read=2
   ->  Bitmap Index Scan on idx_posts_date  (cost=0.00..4.45 rows=16 width=0) (actual time=0.118..0.118 rows=22.00 loops=1)
         Index Cond: ((date >= '2015-01-01'::date) AND (date < '2015-02-01'::date))
         Index Searches: 1
         Buffers: shared read=2
 Planning:
   Buffers: shared hit=24 read=1
 Planning Time: 1.987 ms
 Execution Time: 0.216 ms
(12 rows)
```
---

## Submission and Rubric (20 Points Total)

Please submit the following:

1.  Your final `schema_postgres.sql` file.
2.  A separate SQL file named `indexes.sql` containing all the `CREATE INDEX` statements you used to optimize the queries.
3.  A Markdown document containing your analysis for each of the four scenarios. This document must include:
    *   The "before" and "after" execution plans from `EXPLAIN ANALYZE`.
    *   The provided queries for each scenario with EXPLAIN ANALYZE
    *   Your answers to the analysis questions for each scenario.

