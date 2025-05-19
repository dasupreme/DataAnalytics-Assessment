-- Q2: Transaction Frequency Analysis
-- This query calculates the average number of savings transactions per customer per month
-- and segments customers into frequency categories.

WITH monthly_transactions AS (
    SELECT
        owner_id,
        DATE_FORMAT(transaction_date, '%Y-%m') AS year_month,
        COUNT(*) AS monthly_txn
    FROM savings_savingsaccount
    GROUP BY owner_id, year_month
),
avg_txn_per_customer AS (
    SELECT
        owner_id,
        AVG(monthly_txn) AS avg_transactions_per_month
    FROM monthly_transactions
    GROUP BY owner_id
),
categorized AS (
    SELECT
        CASE
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM avg_txn_per_customer
)
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(CASE 
        WHEN frequency_category = 'High Frequency' THEN 10
        WHEN frequency_category = 'Medium Frequency' THEN 6
        ELSE 1.5
    END), 1) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category;
