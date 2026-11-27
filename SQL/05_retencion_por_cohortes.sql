
-- 5. Definir la cohorte de registro

-- Asignar a cada usuario su cohorte de registro en formato YYYY-MM

SELECT user_id,

    MIN(signup_date) AS signup_date,
    TO_CHAR(DATE_TRUNC('month', MIN(signup_date)), 'YYYY-MM') AS cohort

FROM mercadolibre_retention 
GROUP BY user_id
ORDER BY user_id
LIMIT 5;


-- Calcular retención por cohorte y periodo D7, D14, D21, D28


-- 1) CTE para definir las cohortes

WITH cohort AS (

SELECT
user_id,

TO_CHAR(DATE_TRUNC('month', MIN(signup_date)), 'YYYY-MM') AS cohort
FROM mercadolibre_retention
GROUP BY user_id
),

activity AS (

-- 2) CTE activity: columnas claves de mercadolibre_retention y añadir el cohort 

SELECT

r.user_id,
c.cohort, 
r.day_after_signup,
r.active

FROM mercadolibre_retention r
LEFT JOIN cohort c ON r.user_id = c.user_id
WHERE r.activity_date BETWEEN '2025-01-01' AND '2025-08-31'
)

-- 3) Calcular el porcentaje de retención acumulada por cohorte

SELECT 
    cohort,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN day_after_signup >= 7 AND active = 1 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id),0),1) AS retention_d7_pct,

    ROUND(100.0 * COUNT(DISTINCT CASE WHEN day_after_signup >= 14 AND active = 1 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id),0),1) AS retention_d14_pct,

    ROUND(100.0 * COUNT(DISTINCT CASE WHEN day_after_signup >= 21 AND active = 1 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id),0),1) AS retention_d21_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN day_after_signup >= 28 AND active = 1 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id),0),1) AS retention_d28_pct

FROM activity
GROUP BY cohort
ORDER BY cohort;
