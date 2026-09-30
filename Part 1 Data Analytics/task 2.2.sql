WITH CleanData AS (
    SELECT 
        CAST(temp AS REAL) AS x,
        CAST(traffic_volume AS REAL) AS y
    FROM Metro_Interstate_Traffic_Volume
    -- Filters out the known 0 Kelvin data entry errors in this dataset
    WHERE temp > 100 
)
SELECT 
    (COUNT(*) * SUM(x * y) - SUM(x) * SUM(y)) / 
    (
        SQRT(COUNT(*) * SUM(x * x) - SUM(x) * SUM(x)) * 
        SQRT(COUNT(*) * SUM(y * y) - SUM(y) * SUM(y))
    ) AS pearson_correlation_r
FROM CleanData;

-- direction: since coefficient is positive, when the temperature increases, the traffic volume will increase too
-- strength: ~0.13 a low coefficient which is weak