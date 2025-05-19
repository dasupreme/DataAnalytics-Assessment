-- Q3: Account Inactivity Alert
-- This query identifies plans (savings or investment) with no deposits in the last 365 days.

WITH last_txn AS (
    SELECT
        plan_id,
        owner_id,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    GROUP BY plan_id, owner_id
)
SELECT
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    lt.last_transaction_date,
    DATEDIFF(CURDATE(), lt.last_transaction_date) AS inactivity_days
FROM plans_plan p
JOIN last_txn lt ON p.id = lt.plan_id
WHERE DATEDIFF(CURDATE(), lt.last_transaction_date) > 365;
