# SQL

\-- Loan Default Risk Dashboard

\-- SQL Analysis

\-- Database: loan\_risk\_db

\-- Clean table: credit\_risk\_clean



USE loan\_risk\_db;



\-- =====================================================

\-- 1. CREATE CLEAN TABLE

\-- =====================================================



CREATE TABLE credit\_risk\_clean AS

SELECT DISTINCT \*

FROM credit\_risk\_raw;



\-- =====================================================

\-- 2. DATA CLEANING

\-- =====================================================



\-- Replace invalid ages with NULL

UPDATE credit\_risk\_clean

SET person\_age = NULL

WHERE person\_age > 100;



\-- Fill invalid ages with median age

UPDATE credit\_risk\_clean

SET person\_age = 26

WHERE person\_age IS NULL;





\-- Replace invalid employment lengths with NULL

UPDATE credit\_risk\_clean

SET person\_emp\_length = NULL

WHERE person\_emp\_length < 0

&#x20;  OR person\_emp\_length > 100;



\-- Fill invalid employment lengths with median value

UPDATE credit\_risk\_clean

SET person\_emp\_length = 4

WHERE person\_emp\_length IS NULL;





\-- Replace negative interest rates

UPDATE credit\_risk\_clean

SET loan\_int\_rate = 11.02

WHERE loan\_int\_rate < 0;





\-- Check for remaining NULL values

SELECT

&#x20;   COUNT(\*) AS total\_rows,

&#x20;   SUM(person\_age IS NULL) AS null\_age,

&#x20;   SUM(person\_emp\_length IS NULL) AS null\_employment\_length,

&#x20;   SUM(loan\_int\_rate IS NULL) AS null\_interest\_rate

FROM credit\_risk\_clean;



\-- =====================================================

\-- 3. OVERALL DEFAULT RATE

\-- =====================================================



SELECT

&#x20;   loan\_status,

&#x20;   COUNT(\*) AS total\_loans,

&#x20;   ROUND(COUNT(\*) \* 100.0 / SUM(COUNT(\*)) OVER (), 2) AS percentage

FROM credit\_risk\_clean

GROUP BY loan\_status

ORDER BY loan\_status;



\-- =====================================================

\-- 4. DEFAULT RATE BY LOAN INTENT

\-- =====================================================



SELECT

&#x20;   loan\_intent,

&#x20;   COUNT(\*) AS total\_loans,

&#x20;   SUM(loan\_status) AS defaults,

&#x20;   ROUND(AVG(loan\_status) \* 100, 2) AS default\_rate

FROM credit\_risk\_clean

GROUP BY loan\_intent

ORDER BY default\_rate DESC;



\-- =====================================================

\-- 5. DEFAULT RATE BY INCOME GROUP

\-- =====================================================



SELECT

&#x20;   CASE

&#x20;       WHEN person\_income < 30000 THEN 'Below 30K'

&#x20;       WHEN person\_income < 50000 THEN '30K-50K'

&#x20;       WHEN person\_income < 75000 THEN '50K-75K'

&#x20;       WHEN person\_income < 100000 THEN '75K-100K'

&#x20;       ELSE '100K+'

&#x20;   END AS income\_group,

&#x20;   COUNT(\*) AS total\_loans,

&#x20;   SUM(loan\_status) AS defaults,

&#x20;   ROUND(AVG(loan\_status) \* 100, 2) AS default\_rate

FROM credit\_risk\_clean

GROUP BY

&#x20;   CASE

&#x20;       WHEN person\_income < 30000 THEN 'Below 30K'

&#x20;       WHEN person\_income < 50000 THEN '30K-50K'

&#x20;       WHEN person\_income < 75000 THEN '50K-75K'

&#x20;       WHEN person\_income < 100000 THEN '75K-100K'

&#x20;       ELSE '100K+'

&#x20;   END

ORDER BY MIN(person\_income);



\-- =====================================================

\-- 6. DEFAULT RATE BY LOAN AMOUNT

\-- =====================================================



SELECT

&#x20;   CASE

&#x20;       WHEN loan\_amnt < 5000 THEN 'Below 5K'

&#x20;       WHEN loan\_amnt < 10000 THEN '5K-10K'

&#x20;       WHEN loan\_amnt < 15000 THEN '10K-15K'

&#x20;       WHEN loan\_amnt < 20000 THEN '15K-20K'

&#x20;       ELSE '20K+'

&#x20;   END AS loan\_amount\_group,

&#x20;   COUNT(\*) AS total\_loans,

&#x20;   SUM(loan\_status) AS defaults,

&#x20;   ROUND(AVG(loan\_status) \* 100, 2) AS default\_rate

FROM credit\_risk\_clean

GROUP BY

&#x20;   CASE

&#x20;       WHEN loan\_amnt < 5000 THEN 'Below 5K'

&#x20;       WHEN loan\_amnt < 10000 THEN '5K-10K'

&#x20;       WHEN loan\_amnt < 15000 THEN '10K-15K'

&#x20;       WHEN loan\_amnt < 20000 THEN '15K-20K'

&#x20;       ELSE '20K+'

&#x20;   END

ORDER BY MIN(loan\_amnt);



\-- =====================================================

\-- 7. DEFAULT RATE BY INTEREST RATE GROUP

\-- =====================================================



SELECT

&#x20;   CASE

&#x20;       WHEN loan\_int\_rate < 7 THEN 'Below 7%'

&#x20;       WHEN loan\_int\_rate < 10 THEN '7%-10%'

&#x20;       WHEN loan\_int\_rate < 13 THEN '10%-13%'

&#x20;       WHEN loan\_int\_rate < 16 THEN '13%-16%'

&#x20;       ELSE '16%+'

&#x20;   END AS interest\_rate\_group,

&#x20;   COUNT(\*) AS total\_loans,

&#x20;   SUM(loan\_status) AS defaults,

&#x20;   ROUND(AVG(loan\_status) \* 100, 2) AS default\_rate

FROM credit\_risk\_clean

GROUP BY

&#x20;   CASE

&#x20;       WHEN loan\_int\_rate < 7 THEN 'Below 7%'

&#x20;       WHEN loan\_int\_rate < 10 THEN '7%-10%'

&#x20;       WHEN loan\_int\_rate < 13 THEN '10%-13%'

&#x20;       WHEN loan\_int\_rate < 16 THEN '13%-16%'

&#x20;       ELSE '16%+'

&#x20;   END

ORDER BY MIN(loan\_int\_rate);



\-- =====================================================

\-- 8. DEFAULT RATE BY LOAN GRADE

\-- =====================================================



SELECT

&#x20;   loan\_grade,

&#x20;   COUNT(\*) AS total\_loans,

&#x20;   SUM(loan\_status) AS defaults,

&#x20;   ROUND(AVG(loan\_status) \* 100, 2) AS default\_rate

FROM credit\_risk\_clean

GROUP BY loan\_grade

ORDER BY loan\_grade;



\-- =====================================================

\-- 9. DEFAULT RATE BY AGE GROUP

\-- =====================================================



SELECT

&#x20;   CASE

&#x20;       WHEN person\_age < 25 THEN 'Below 25'

&#x20;       WHEN person\_age < 30 THEN '25-29'

&#x20;       WHEN person\_age < 35 THEN '30-34'

&#x20;       WHEN person\_age < 40 THEN '35-39'

&#x20;       WHEN person\_age < 50 THEN '40-49'

&#x20;       ELSE '50+'

&#x20;   END AS age\_group,

&#x20;   COUNT(\*) AS total\_loans,

&#x20;   SUM(loan\_status) AS defaults,

&#x20;   ROUND(AVG(loan\_status) \* 100, 2) AS default\_rate

FROM credit\_risk\_clean

GROUP BY

&#x20;   CASE

&#x20;       WHEN person\_age < 25 THEN 'Below 25'

&#x20;       WHEN person\_age < 30 THEN '25-29'

&#x20;       WHEN person\_age < 35 THEN '30-34'

&#x20;       WHEN person\_age < 40 THEN '35-39'

&#x20;       WHEN person\_age < 50 THEN '40-49'

&#x20;       ELSE '50+'

&#x20;   END

ORDER BY MIN(person\_age);



\-- =====================================================

\-- 10. DEFAULT RATE BY HOME OWNERSHIP

\-- =====================================================



SELECT

&#x20;   person\_home\_ownership,

&#x20;   COUNT(\*) AS total\_loans,

&#x20;   SUM(loan\_status) AS defaults,

&#x20;   ROUND(AVG(loan\_status) \* 100, 2) AS default\_rate

FROM credit\_risk\_clean

GROUP BY person\_home\_ownership

ORDER BY default\_rate DESC;



\-- =====================================================

\-- 11. DEFAULT RATE BY EMPLOYMENT LENGTH

\-- =====================================================



SELECT

&#x20;   CASE

&#x20;       WHEN person\_emp\_length <= 1 THEN '0-1 years'

&#x20;       WHEN person\_emp\_length <= 4 THEN '2-4 years'

&#x20;       WHEN person\_emp\_length <= 7 THEN '5-7 years'

&#x20;       ELSE '8+ years'

&#x20;   END AS employment\_length\_group,

&#x20;   COUNT(\*) AS total\_loans,

&#x20;   SUM(loan\_status) AS defaults,

&#x20;   ROUND(AVG(loan\_status) \* 100, 2) AS default\_rate

FROM credit\_risk\_clean

GROUP BY

&#x20;   CASE

&#x20;       WHEN person\_emp\_length <= 1 THEN '0-1 years'

&#x20;       WHEN person\_emp\_length <= 4 THEN '2-4 years'

&#x20;       WHEN person\_emp\_length <= 7 THEN '5-7 years'

&#x20;       ELSE '8+ years'

&#x20;   END

ORDER BY MIN(person\_emp\_length);









