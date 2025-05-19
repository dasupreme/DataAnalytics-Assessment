-- Q4: Customer Lifetime Value (CLV) Estimation
-- This query estimates CLV based on tenure, total deposits, and a fixed profit rate.

WITH customer_txn AS (
    SELECT
        owner_id,
        COUNT(*) AS total_transactions,
        SUM(confirmed_amount) AS total_value
    FROM savings_savingsaccount
    GROUP BY owner_id
),
user_tenure AS (
    SELECT
        id AS customer_id,
        name,
        TIMESTAMPDIFF(MONTH, created_on, CURDATE()) AS tenure_months
    FROM users_customuser
)
SELECT
    u.customer_id,
    u.name,
    u.tenure_months,
    ct.total_transactions,
    ROUND(
        (ct.total_transactions / u.tenure_months) * 12 * (0.001 * ct.total_value),
        2
    ) AS estimated_clv
FROM user_tenure u
JOIN customer_txn ct ON u.customer_id = ct.owner_id
WHERE u.tenure_months > 0
ORDER BY estimated_clv DESC;
