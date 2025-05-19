-- Q1: High-Value Customers with Multiple Products
-- This query retrieves customers who have both a funded savings plan and a funded investment plan.
-- It calculates total confirmed deposits and filters based on presence in both product types.

SELECT
    u.id AS owner_id,
    u.name,
    COUNT(DISTINCT s.plan_id) AS savings_count,
    COUNT(DISTINCT i.plan_id) AS investment_count,
    ROUND(SUM(sa.confirmed_amount) / 100, 2) AS total_deposits
FROM users_customuser u
JOIN plans_plan s ON u.id = s.owner_id AND s.is_regular_savings = 1
JOIN plans_plan i ON u.id = i.owner_id AND i.is_a_fund = 1
JOIN savings_savingsaccount sa ON u.id = sa.owner_id
GROUP BY u.id, u.name
ORDER BY total_deposits DESC;
